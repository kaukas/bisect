require "../spec_helper"
require "../../src/bisect"

Spectator.describe Bisect::One do
  it "returns nil for an empty array" do
    expect(Bisect::One.new([] of String).find { false }).to eq(nil)
  end

  it "returns the only item" do
    expect(Bisect::One.new([3]).find { true }).to eq(3)
  end

  it "returns nothing if nothing is ever truthy" do
    expect(Bisect::One.new([3]).find { false }).to eq(nil)
  end

  it "calls the block and returns the item that the block is truthy for" do
    expect(Bisect::One.new([3, 4]).find { |is| is.includes?(4) }).to eq(4)
  end

  it "first verifies that all items are truthy" do
    arrays = [] of Array(Int32)
    item = Bisect::One.new([3, 4]).find do |is|
      arrays << is
      is.includes?(4)
    end
    expect(item).to eq(4)
    expect(arrays[0]).to eq([3, 4])
  end

  it "then checks the first half" do
    arrays = [] of Array(Int32)
    item = Bisect::One.new([3, 4]).find do |is|
      arrays << is
      is.includes?(4)
    end
    expect(item).to eq(4)
    expect(arrays[1]).to eq([3])
  end

  it "then checks the second half" do
    arrays = [] of Array(Int32)
    item = Bisect::One.new([3, 4]).find do |is|
      arrays << is
      is.includes?(4)
    end
    expect(item).to eq(4)
    expect(arrays[2]).to eq([4])
  end

  it "handles an odd count of items" do
    expect(Bisect::One.new([3, 4, 5]).find { |is| is.includes?(5) }).to eq(5)
  end
end
