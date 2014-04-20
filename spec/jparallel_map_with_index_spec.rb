require "bundler/setup"
require "jparallel"

describe Jparallel do
  let(:jp) { Jparallel.new 6 }
  let(:input_array) { (10..15).to_a }
  let(:error_array) { [2,1,0] }

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

    it "returns timeouts in the output" do
      result = jp.map_with_index((0..20).to_a, timeout: 0.001) do |x, index|
        sleep(0.001)
        x
      end
      expect(result.any? {|x| x.is_a?(TimeoutError)}).
        to be(true)
    end
  end
end
