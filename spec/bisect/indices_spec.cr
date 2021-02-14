require "../spec_helper"
require "../../src/bisect/indices"

Spectator.describe Bisect::Indices do
  it "returns nothing for 0 items" do
    expect(Bisect::Indices.find(0) { |_, _| true }).to eq(nil)
  end

  it "returns the only tuple for a single item" do
    expect(Bisect::Indices.find(1) { |_, _| true }).to eq(0)
  end

  it "checks the full list, then the first part, then the second part" do
    results = [true, # whole list - interesting
               false, # item 0 - uninteresting
               true] # item 1 - interesting
    indices = [] of Tuple(Int32, Int32)
    output = Bisect::Indices.find(2) do |left, right|
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
    output = Bisect::Indices.find(3) do |left, right|
      indices << {left, right}
      results.shift
    end
    expect(output).to eq(2)
    expect(indices).to eq([{0, 2}, {0, 1}, {2, 2}])
  end
end
