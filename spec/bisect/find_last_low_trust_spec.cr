require "../spec_helper"
require "../../src/bisect/find_last_low_trust"

Spectator.describe Bisect::FindLastLowTrust do
  describe "#find" do
    it "returns nil for an empty array" do
      expect(Bisect::FindLastLowTrust.new([] of String).find { false }).
        to eq([nil, nil])
      expect(Bisect::FindLastLowTrust.new([] of String).find { true }).
        to eq([nil, nil])
    end

    it "returns the only item" do
      expect(Bisect::FindLastLowTrust.new(["3"]).find { true }).to eq(["3", 1])
    end

    it "returns nothing if nothing is interesting" do
      expect(Bisect::FindLastLowTrust.new(["3"]).find { false }).
        to eq([nil, nil])
    end

    it "returns the single interesting item" do
      expect(
        Bisect::FindLastLowTrust.new(%w[3 4]).find { |item| item == "3" }
      ).to eq(["3", 1])
    end

    it "handles an odd number of items" do
      expect(
        Bisect::FindLastLowTrust.new(%w[3 4 5]).find { |item| item <= "4" }
      ).to eq(["4", 2])
    end
  end

  describe "#indices" do
    it "returns nothing for 0 items" do
      expect(Bisect::FindLastLowTrust.new([] of String).indices { false }).
        to eq(nil)
      expect(Bisect::FindLastLowTrust.new([] of String).indices { true }).
        to eq(nil)
    end

    it "returns nothing for a single uninteresting item" do
      expect(Bisect::FindLastLowTrust.new(["1"]).indices { false }).to eq(nil)
    end

    it "returns the only index for a single interesting item" do
      expect(Bisect::FindLastLowTrust.new(["1"]).indices { true }).to eq(0)
    end

    it "returns the last index for all interesting items" do
      expect(Bisect::FindLastLowTrust.new(%w[1 2 3]).indices { true }).to eq(2)
    end

    it "emits the first index, then the last index" do
      results = {0 => true, 1 => false}
      indices = [] of Int32
      output = Bisect::FindLastLowTrust.new(%w[1 2]).indices do |i|
        indices << i
        results[i]
      end
      expect(output).to eq(0)
      expect(indices).to eq([0, 1])
    end

    it "then emits the middle interesting item" do
      results = {0 => true, 1 => true, 2 => false}
      indices = [] of Int32
      output = Bisect::FindLastLowTrust.new(%w[1 2 3]).indices do |i|
        indices << i
        results[i]
      end
      expect(output).to eq(1)
      expect(indices).to eq([0, 2, 1])
    end

    it "handles an even number of items" do
      results = {0 => true, 1 => true, 2 => false, 3 => false}
      indices = [] of Int32
      output = Bisect::FindLastLowTrust.new(%w[1 2 3 4]).indices do |i|
        indices << i
        results[i]
      end
      expect(output).to eq(1)
      expect(indices).to eq([0, 3, 1, 2])
    end
  end
end
