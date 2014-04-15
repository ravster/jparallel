require "bundler/setup"
require "jparallel"

describe Jparallel do
  let(:jp) { Jparallel.new 6 }
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

    let(:timeout_array_result) do
      jp.map((0..20).to_a, timeout: 0.1) { |x| sleep(0.1) }
    end

    it "returns timeouts in the output" do
      expect(timeout_array_result.any?{ |x| x.is_a?(TimeoutError)}).
        to be(true)
      end
  end
end
