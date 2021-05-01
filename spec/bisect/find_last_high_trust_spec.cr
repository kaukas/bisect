require "../spec_helper"
require "../../src/bisect/find_last_high_trust"

Spectator.describe Bisect::FindLastHighTrust do
  describe "#indices" do
    it "returns nothing for 0 items" do
      expect(Bisect::FindLastHighTrust.indices(0) { false }).to eq(nil)
      expect(Bisect::FindLastHighTrust.indices(0) { true }).to eq(nil)
    end

    it "assumes the single index is interesting" do
      expect(Bisect::FindLastHighTrust.indices(1) { false }).to eq(0)
    end

    it "emits the last index only" do
      indices = [] of Int32
      output = Bisect::FindLastHighTrust.indices(2) do |i|
        indices << i
        false
      end
      expect(output).to eq(0)
      expect(indices).to eq([1])
    end

    it "then emits the middle interesting item" do
      results = {1 => true, 2 => false}
      indices = [] of Int32
      output = Bisect::FindLastHighTrust.indices(3) do |i|
        indices << i
        results[i]
      end
      expect(output).to eq(1)
      expect(indices).to eq([2, 1])
    end

    it "handles an even number of items" do
      results = {1 => true, 2 => true, 3 => false, 4 => false}
      indices = [] of Int32
      output = Bisect::FindLastHighTrust.indices(4) do |i|
        indices << i
        results[i]
      end
      expect(output).to eq(2)
      expect(indices).to eq([3, 1, 2])
    end
  end
end
