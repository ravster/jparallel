require "bundler/setup"
require "thread/pool"

class Jparallel
  def initialize poolsize
    @pool = Thread.pool poolsize
  end

  def map (input_array, &block)
    output_array = Array.new input_array.length

    input_array.each_with_index do |item, index|
      @pool.process do
        output_array[index] = yield(item)
      end
    end

    output_array
  end

  def map_with_index (input_array, &block)
    output_array = Array.new input_array.size

    input_array.each_with_index do |item, index|
      @pool.process do
        output_array[index] = yield(item, index)
      end
    end

    output_array
  end

  def hashmap (input_hash, &block)
    output_hash = {}

    input_hash.each_pair do |key, value|
      @pool.process do
        output_hash[key] = yield(key, value)
      end
    end

    output_hash
  end
end
