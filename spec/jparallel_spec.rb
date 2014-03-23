require "bundler/setup"
require "jparallel"

describe Jparallel do
  let(:jp) { Jparallel.new 6 }

  describe "mapping functions" do
    let(:input_array) { (10..15).to_a }
    let(:error_array) { [2,1,0] }

    describe "#map" do
      let(:multiply_by_2) do
        jp.map(input_array) { |x| x * 2 }
      end

      let(:regular_array_map) do
        input_array.map { |x| x * 2 }
      end

      it "mimics Array#map" do
        expect(multiply_by_2).to eql(regular_array_map)
      end

      let(:error_array_result) do
        jp.map(error_array) { |x| 12 / x }
      end

      it "returns an array even when there is an exception in one of the input" do
        expect(error_array_result).to be_instance_of Array
      end

      it "stores the exception in the result" do
        expect(error_array_result.last).to be_a StandardError
      end
    end

    describe "#map_with_index" do
      let(:jp_map_with_index) do
        jp.map_with_index(input_array) do |x, index|
          "#{x} is at index #{index}"
        end
      end

      it "mimics Array#each_with_index#map" do
        expect(jp_map_with_index).to eql(
          input_array.each_with_index.map do |x, index|
            "#{x} is at index #{index}"
          end
        )
      end

      let(:error_array_result) do
        jp.map_with_index(error_array) do |x, index|
          if index == 2
            raise "random error"
          else
            x
          end
        end
      end

      it "returns errors within the array" do
        expect(error_array_result.last).to be_a StandardError
      end
    end
  end

  describe "#hashmap" do
    let(:input_hash) { {a: 0, b: 1, c: 2} }

    let(:hash_by_2) do
      jp.hashmap(input_hash) { |key, val| val * 2 }
    end

    it "mimics Hash[ Hash#map ]" do
      expect(hash_by_2).to eql(
        Hash[
          input_hash.map { |key, val| [ key, val * 2 ] }
        ]
      )
    end

    let(:error_result) do
      jp.hashmap(input_hash) { |key, val| 12 / 0 }
    end

    it "returns errors within the hash" do
      expect(error_result[:a]).to be_a StandardError
    end
  end
end
