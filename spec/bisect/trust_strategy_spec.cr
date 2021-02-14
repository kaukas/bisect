require "../spec_helper"
require "../../src/bisect/trust_strategy"

Spectator.describe Bisect::TrustStrategy do
  it "assumes one item is always interesting" do
    expect(Bisect::TrustStrategy.find([3]) { false }).to eq(3)
  end

  it "checks the first part only" do
    subsets = [] of Array(Int32)
    output = Bisect::TrustStrategy.find([3, 4]) do |subset|
      subsets << subset
      subset.includes?(4)
    end
    expect(subsets).to eq([[3]])
    expect(output).to eq(4)
  end

  it "handles an odd number of items" do
    subsets = [] of Array(Int32)
    output = Bisect::TrustStrategy.find([3, 4, 5]) do |subset|
      subsets << subset
      subset.includes?(4)
    end
    expect(subsets).to eq([[3, 4], [3]])
    expect(output).to eq(4)
  end
end
