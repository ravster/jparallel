require "bundler/setup"
require "jparallel"

describe Jparallel do
  describe "#map" do
    let(:multiply_by_2) do
      Jparallel.map([1,2,3,4,5]) do |x|
        x * 2
      end
    end

    let(:manual_poolsize) do
      Jparallel.map([1,2,3,4,5], 200) do |x|
        x * 2
      end
    end

    it "returns an array" do
      expect(multiply_by_2).to be_a(Array)
    end

    it "has the output in the correct order" do
      expect(multiply_by_2).to eql([2,4,6,8,10])
    end

    it "works with a given poolsize" do
      expect(manual_poolsize).to eql([2,4,6,8,10])
    end
  end

  describe "#hashmap" do
    let(:hash_by_2) do
      Jparallel.hashmap({a: 1, b: 2, c: 3}) do |key, val|
        val * 2
      end
    end

    it "returns a hash" do
      expect(hash_by_2).to be_a(Hash)
    end

    it "returns a new hash with correct values" do
      expect(hash_by_2).to eql({a: 2, b: 4, c: 6})
    end
  end
end
