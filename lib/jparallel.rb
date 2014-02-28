require "bundler/setup"
require "thread/pool"

module Jparallel
  def self.processor_count
    java.lang.Runtime.getRuntime.availableProcessors
  end

  def self.map (input_array, poolsize = processor_count, &block)
    output_array = Array.new input_array.length
    thread_pool = Thread.pool poolsize

    input_array.each_with_index do |item, index|
      thread_pool.process do
        output_array[index] = yield(item)
      end
    end

    thread_pool.shutdown # blocks till all the work is done.
    output_array
  end

  def self.map_with_index (input_array, poolsize = processor_count, &block)
    output_array = Array.new input_array.size
    thread_pool = Thread.pool poolsize

    input_array.each_with_index do |item, index|
      thread_pool.process do
        output_array[index] = yield(item, index)
      end
    end

    thread_pool.shutdown
    output_array
  end

  def self.hashmap (input_hash, poolsize = processor_count, &block)
    output_hash = {}
    thread_pool = Thread.pool poolsize

    input_hash.each_pair do |key, value|
      thread_pool.process do
        output_hash[key] = yield(key, value)
      end
    end

    thread_pool.shutdown
    output_hash
  end
end
