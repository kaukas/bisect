require "../spec_helper"
require "../../src/bisect/find_first_high_trust"

Spectator.describe Bisect::FindFirstHighTrust do
  describe "#indices" do
    it "returns nothing for 0 items" do
      expect(Bisect::FindFirstHighTrust.indices(0) { false }).to eq(nil)
      expect(Bisect::FindFirstHighTrust.indices(0) { true }).to eq(nil)
    end

    it "assumes the single index is interesting" do
      expect(Bisect::FindFirstHighTrust.indices(1) { false }).to eq(0)
    end

    it "emits the first index only" do
      indices = [] of Int32
      output = Bisect::FindFirstHighTrust.indices(2) do |i|
        indices << i
        false
      end
      expect(output).to eq(1)
      expect(indices).to eq([0])
    end

    it "then emits the middle interesting item" do
      results = {0 => false, 1 => true}
      indices = [] of Int32
      output = Bisect::FindFirstHighTrust.indices(3) do |i|
        indices << i
        results[i]
      end
      expect(output).to eq(1)
      expect(indices).to eq([0, 1])
    end

    it "handles an even number of items" do
      results = {0 => false, 1 => false, 2 => true}
      indices = [] of Int32
      output = Bisect::FindFirstHighTrust.indices(4) do |i|
        indices << i
        results[i]
      end
      expect(output).to eq(2)
      expect(indices).to eq([0, 1, 2])
    end
  end
end
