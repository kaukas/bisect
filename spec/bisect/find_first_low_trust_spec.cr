require "../spec_helper"
require "../../src/bisect/find_first_low_trust"

Spectator.describe Bisect::FindFirstLowTrust do
  describe "#find" do
    it "returns nil for an empty array" do
      expect(Bisect::FindFirstLowTrust.find([] of Int32) { false }).
        to eq([nil, nil])
      expect(Bisect::FindFirstLowTrust.find([] of Int32) { true }).
        to eq([nil, nil])
    end

    it "returns the only item" do
      expect(Bisect::FindFirstLowTrust.find([3]) { true }).to eq([3, 1])
    end

    it "returns nothing if nothing is interesting" do
      expect(Bisect::FindFirstLowTrust.find([3]) { false }).to eq([nil, nil])
    end

    it "returns the single interesting item" do
      item, index = Bisect::FindFirstLowTrust.find([3, 4]) { |item| item == 4 }
      expect(item).to eq(4)
      expect(index).to eq(2)
    end

    it "handles an odd number of items" do
      item, index = Bisect::FindFirstLowTrust.find([3, 4, 5]) do |item|
        item >= 4
      end
      expect(item).to eq(4)
      expect(index).to eq(2)
    end
  end

  describe "#indices" do
    it "returns nothing for 0 items" do
      expect(Bisect::FindFirstLowTrust.indices(0) { false }).to eq(nil)
      expect(Bisect::FindFirstLowTrust.indices(0) { true }).to eq(nil)
    end

    it "returns nothing for a single uninteresting item" do
      expect(Bisect::FindFirstLowTrust.indices(1) { false }).to eq(nil)
    end

    it "returns the only index for a single interesting item" do
      expect(Bisect::FindFirstLowTrust.indices(1) { true }).to eq(0)
    end

    it "returns the first index for all interesting items" do
      expect(Bisect::FindFirstLowTrust.indices(3) { true }).to eq(0)
    end

    it "emits the first index, then the last index" do
      results = {0 => false, 1 => true}
      indices = [] of Int32
      output = Bisect::FindFirstLowTrust.indices(2) do |i|
        indices << i
        results[i]
      end
      expect(output).to eq(1)
      expect(indices).to eq([0, 1])
    end

    it "then emits the middle interesting item" do
      results = {0 => false, 1 => true, 2 => true}
      indices = [] of Int32
      output = Bisect::FindFirstLowTrust.indices(3) do |i|
        indices << i
        results[i]
      end
      expect(output).to eq(1)
      expect(indices).to eq([0, 2, 1])
    end

    it "handles an even number of items" do
      results = {0 => false, 1 => false, 2 => true, 3 => true}
      indices = [] of Int32
      output = Bisect::FindFirstLowTrust.indices(4) do |i|
        indices << i
        results[i]
      end
      expect(output).to eq(2)
      expect(indices).to eq([0, 3, 1, 2])
    end
  end
end
