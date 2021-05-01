require "../spec_helper"
require "../../src/bisect/find_last_low_trust"

Spectator.describe Bisect::FindLastLowTrust do
  describe "#find" do
    it "returns nil for an empty array" do
      expect(Bisect::FindLastLowTrust.find([] of Int32) { false }).
        to eq([nil, nil])
      expect(Bisect::FindLastLowTrust.find([] of Int32) { true }).
        to eq([nil, nil])
    end

    it "returns the only item" do
      expect(Bisect::FindLastLowTrust.find([3]) { true }).to eq([3, 1])
    end

    it "returns nothing if nothing is interesting" do
      expect(Bisect::FindLastLowTrust.find([3]) { false }).to eq([nil, nil])
    end

    it "returns the single interesting item" do
      item, index = Bisect::FindLastLowTrust.find([3, 4]) { |item| item == 3 }
      expect(item).to eq(3)
      expect(index).to eq(1)
    end

    it "handles an odd number of items" do
      item, index = Bisect::FindLastLowTrust.find([3, 4, 5]) do |item|
        item <= 4
      end
      expect(item).to eq(4)
      expect(index).to eq(2)
    end
  end

  describe "#indices" do
    it "returns nothing for 0 items" do
      expect(Bisect::FindLastLowTrust.indices(0) { false }).to eq(nil)
      expect(Bisect::FindLastLowTrust.indices(0) { true }).to eq(nil)
    end

    it "returns nothing for a single uninteresting item" do
      expect(Bisect::FindLastLowTrust.indices(1) { false }).to eq(nil)
    end

    it "returns the only index for a single interesting item" do
      expect(Bisect::FindLastLowTrust.indices(1) { true }).to eq(0)
    end

    it "returns the last index for all interesting items" do
      expect(Bisect::FindLastLowTrust.indices(3) { true }).to eq(2)
    end

    it "emits the first index, then the last index" do
      results = {0 => true, 1 => false}
      indices = [] of Int32
      output = Bisect::FindLastLowTrust.indices(2) do |i|
        indices << i
        results[i]
      end
      expect(output).to eq(0)
      expect(indices).to eq([0, 1])
    end

    it "then emits the middle interesting item" do
      results = {0 => true, 1 => true, 2 => false}
      indices = [] of Int32
      output = Bisect::FindLastLowTrust.indices(3) do |i|
        indices << i
        results[i]
      end
      expect(output).to eq(1)
      expect(indices).to eq([0, 2, 1])
    end

    it "handles an even number of items" do
      results = {0 => true, 1 => true, 2 => false, 3 => false}
      indices = [] of Int32
      output = Bisect::FindLastLowTrust.indices(4) do |i|
        indices << i
        results[i]
      end
      expect(output).to eq(1)
      expect(indices).to eq([0, 3, 1, 2])
    end
  end
end
