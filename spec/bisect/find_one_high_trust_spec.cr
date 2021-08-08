require "../spec_helper"
require "../../src/bisect/find_one_high_trust"

Spectator.describe Bisect::FindOneHighTrust do
  describe "#find" do
    it "assumes one item is always interesting" do
      expect(Bisect::FindOneHighTrust.new([3]).find { false }).to eq([3, 1])
    end

    it "checks the first part only" do
      subsets = [] of Array(Int32)
      item, index = Bisect::FindOneHighTrust.new([3, 4]).find do |subset|
        subsets << subset
        subset.includes?(4)
      end
      expect(subsets).to eq([[3]])
      expect(item).to eq(4)
      expect(index).to eq(2)
    end

    it "handles an odd number of items" do
      subsets = [] of Array(Int32)
      item, index = Bisect::FindOneHighTrust.new([3, 4, 5]).find do |subset|
        subsets << subset
        subset.includes?(4)
      end
      expect(subsets).to eq([[3, 4], [3]])
      expect(item).to eq(4)
      expect(index).to eq(2)
    end

    it "can confirm a limited number of items at a time" do
      subsets = [] of Array(Int32)
      item, idx = Bisect::FindOneHighTrust.new((1..5).to_a, 2).find do |subset|
        subsets << subset
        subset.includes?(5)
      end
      expect(subsets).to eq([[1, 2], [3, 4]])
      expect(item).to eq(5)
      expect(idx).to eq(5)
    end
  end
end
