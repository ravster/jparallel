require "bundler/setup"
require "jparallel"

describe Jparallel do
  let(:jp) { Jparallel.new 6 }

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

    let(:timeout_hash_result) do
      big_array = (0..20).to_a.map do |x|
        [x,x]
      end
      big_hash = Hash[big_array]
      jp.hashmap(big_hash, timeout: 0.01) do |k,v|
        sleep(0.01)
        v
      end
    end

    it "returns timeouts in the output" do
      expect(timeout_hash_result.any? {|k,v| v.is_a?(TimeoutError)}).
        to be(true)
    end
  end
end
