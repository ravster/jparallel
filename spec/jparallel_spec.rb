require "bundler/setup"
require "jparallel"

describe Jparallel do
  let(:jp) { Jparallel.new 6 }

  describe "mapping functions" do
    let(:input_array) { (10..15).to_a }

    describe "::map" do
      let(:multiply_by_2) do
        jp.map(input_array) { |x| x * 2 }
      end

      let(:regular_array_map) do
        input_array.map { |x| x * 2 }
      end

      it "mimics Array#map" do
        expect(multiply_by_2).to eql(regular_array_map)
      end
    end

    describe "::map_with_index" do
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
    end
  end

  describe "::hashmap" do
    let(:input_hash) { {a: 1, b: 2, c: 3} }

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
  end
end
