require "bundler/setup"
require "thread/pool"
require "thread/future"

class Jparallel
  def initialize poolsize
    @pool = Thread.pool poolsize
  end

  def map (input_array, ops={}, &block)
    timeout = ops[:timeout]
    output_array = Array.new input_array.length
    start_time = Time.now

    input_array.each_with_index do |item, index|
      output_array[index] = Thread.future @pool do
        if !timeout.nil? &&
            ( Time.now - start_time ) > timeout
          TimeoutError.new("Timed out before item #{index}")
        else
          begin
            yield(item)
          rescue => e
            e
          end
        end
      end
    end

    output_array.map(&:value)
  end

  def map_with_index (input_array, ops={}, &block)
    timeout = ops[:timeout]
    output_array = Array.new input_array.size
    start_time = Time.now

    input_array.each_with_index do |item, index|
      output_array[index] = Thread.future @pool do
        if !timeout.nil? &&
            (Time.now - start_time) > timeout
          TimeoutError.new("Timed out before item #{index}")
        else
          begin
            yield(item, index)
          rescue => e
            e
          end
        end
      end
    end

    output_array.map(&:value)
  end

  def hashmap (input_hash, ops={}, &block)
    timeout = ops[:timeout]
    output_hash = {}
    start_time = Time.now

    input_hash.each_pair do |key, value|
      output_hash[key] = Thread.future @pool do
        if !timeout.nil? &&
            (Time.now - start_time) > timeout
          TimeoutError.new("Timed out before item #{key}")
        else
          begin
            yield(key, value)
          rescue => e
            e
          end
        end
      end
    end

    output_hash.each_pair do |key, value_future|
      output_hash[key] = value_future.value
    end

    output_hash
  end
end
