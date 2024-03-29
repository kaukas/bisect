require "../spec_helper"
require "../../src/bisect/find_one_low_trust"

Spectator.describe Bisect::FindOneLowTrust do
  describe "#find" do
    it "returns nil for an empty array" do
      expect(Bisect::FindOneLowTrust.new([] of Int32).find { false }).
        to eq([nil, nil])
      expect(Bisect::FindOneLowTrust.new([] of Int32).find { true }).
        to eq([nil, nil])
    end

    it "returns the only item" do
      expect(Bisect::FindOneLowTrust.new([3]).find { true }).to eq([3, 1])
    end

    it "returns nothing if nothing is interesting" do
      expect(Bisect::FindOneLowTrust.new([3]).find { false }).to eq([nil, nil])
    end

    it "returns the single interesting item" do
      subsets = [] of Array(Int32)
      item, index = Bisect::FindOneLowTrust.new([3, 4]).find do |subset|
        subsets << subset
        subset.includes?(4)
      end
      expect(item).to eq(4)
      expect(index).to eq(2)
      expect(subsets).to eq([[3, 4], [3], [4]])
    end

    it "handles an odd number of items" do
      subsets = [] of Array(Int32)
      item, index = Bisect::FindOneLowTrust.new([3, 4, 5]).find do |subset|
        subsets << subset
        subset.includes?(4)
      end
      expect(item).to eq(4)
      expect(index).to eq(2)
      expect(subsets).to eq([[3, 4, 5], [3, 4], [3], [4]])
    end

    it "can confirm a limited number of items at a time" do
      subsets = [] of Array(Int32)
      item, index = Bisect::FindOneLowTrust.new([3, 4, 5], 2).find do |subset|
        subsets << subset
        subset.includes?(5)
      end
      expect(item).to eq(5)
      expect(index).to eq(3)
      expect(subsets).to eq([[3, 4], [5]])
    end
  end

  describe "#indices" do
    it "returns nothing for 0 items" do
      expect(Bisect::FindOneLowTrust.new([] of String).indices { |_, _| true }).
        to eq(nil)
    end

    it "returns the only tuple for a single item" do
      expect(Bisect::FindOneLowTrust.new(["1"]).indices { |_, _| true }).
        to eq(0)
    end

    it "checks the full list, then the first part, then the second part" do
      results = [true, # whole list - interesting
                 false, # item 0 - uninteresting
                 true] # item 1 - interesting
      indices = [] of Tuple(Int32, Int32)
      output = Bisect::FindOneLowTrust.new(%w[1 2]).indices do |left, right|
        indices << {left, right}
        results.shift
      end
      expect(output).to eq(1)
      expect(indices).to eq([{0, 1}, {0, 0}, {1, 1}])
    end

    it "handles an odd number of items" do
      results = [true, # whole list - interesting
                 false, # items 0 and 1 - uninteresting
                 true] # item 2 - interesting
      indices = [] of Tuple(Int32, Int32)
      output = Bisect::FindOneLowTrust.new(%w[1 2 3]).indices do |left, right|
        indices << {left, right}
        results.shift
      end
      expect(output).to eq(2)
      expect(indices).to eq([{0, 2}, {0, 1}, {2, 2}])
    end

    it "can confirm a limited number of items at a time" do
      results = [false, # only two items - uninteresting
                 true, # items 3 and 4 - interesting
                 true] # item 3 - interesting
      indices = [] of Tuple(Int32, Int32)
      output = Bisect::FindOneLowTrust.new([1] * 5, 2).indices do |left, right|
        indices << {left, right}
        results.shift
      end
      expect(indices).to eq([{0, 1}, {2, 3}, {2, 2}])
      expect(output).to eq(2)
    end
  end
end
