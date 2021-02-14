require "../spec_helper"
require "../../src/bisect/no_trust_strategy"

Spectator.describe Bisect::NoTrustStrategy do
  it "returns nil for an empty array" do
    expect(Bisect::NoTrustStrategy.find([] of Int32) { false }).to eq(nil)
    expect(Bisect::NoTrustStrategy.find([] of Int32) { true }).to eq(nil)
  end

  it "returns the only item" do
    expect(Bisect::NoTrustStrategy.find([3]) { true }).to eq(3)
  end

  it "returns nothing if nothing is ever truthy" do
    expect(Bisect::NoTrustStrategy.find([3]) { false }).to eq(nil)
  end

  it "returns the single interesting item" do
    subsets = [] of Array(Int32)
    output = Bisect::NoTrustStrategy.find([3, 4]) do |subset|
      subsets << subset
      subset.includes?(4)
    end
    expect(output).to eq(4)
    expect(subsets).to eq([[3, 4], [3], [4]])
  end

  it "handles an odd number of items" do
    subsets = [] of Array(Int32)
    output = Bisect::NoTrustStrategy.find([3, 4, 5]) do |subset|
      subsets << subset
      subset.includes?(4)
    end
    expect(output).to eq(4)
    expect(subsets).to eq([[3, 4, 5], [3, 4], [3], [4]])
  end
end
