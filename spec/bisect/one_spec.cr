require "../spec_helper"
require "../../src/bisect"

Spectator.describe Bisect::One do
  it "returns the interesting item" do
    expect(Bisect::One.find(Bisect::NoTrustStrategy, [3, 4]) do |subset|
      subset.includes?(4)
    end).to eq(4)
  end

  it "returns nil if nothing found" do
    expect(Bisect::One.find(Bisect::NoTrustStrategy, [3, 4]) do |subset|
      subset.includes?(5)
    end).to eq(nil)
  end
end
