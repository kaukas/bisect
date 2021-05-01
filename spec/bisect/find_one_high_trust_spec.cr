require "../spec_helper"
require "../../src/bisect/find_one_high_trust"

Spectator.describe Bisect::FindOneHighTrust do
  describe "#find" do
    it "assumes one item is always interesting" do
      expect(Bisect::FindOneHighTrust.find([3]) { false }).to eq([3, 1])
    end

    it "checks the first part only" do
      subsets = [] of Array(Int32)
      item, index = Bisect::FindOneHighTrust.find([3, 4]) do |subset|
        subsets << subset
        subset.includes?(4)
      end
      expect(subsets).to eq([[3]])
      expect(item).to eq(4)
      expect(index).to eq(2)
    end

    it "handles an odd number of items" do
      subsets = [] of Array(Int32)
      item, index = Bisect::FindOneHighTrust.find([3, 4, 5]) do |subset|
        subsets << subset
        subset.includes?(4)
      end
      expect(subsets).to eq([[3, 4], [3]])
      expect(item).to eq(4)
      expect(index).to eq(2)
    end
  end
end
