require "../spec_helper"
require "../../src/bisect/cli"

Spectator.describe Bisect::Cli do
  it "asks to confirm and prints the winning item" do
    stdin = IO::Memory.new("3\n\n+\n")
    stdout = IO::Memory.new
    Bisect::Cli.run(stdin, stdout)
    expect(stdout.to_s.lines).to eq([
      "Enter the list of items, one per line, and an empty line at the end:",
      "Consider this list of items:",
      "3",
      "",
      "Are they interesting? Enter + or -: The interesting item:",
      "3"
    ])
  end

  it "prints nothing if no items" do
    stdin = IO::Memory.new("")
    stdout = IO::Memory.new
    Bisect::Cli.run(stdin, stdout)
    expect(stdout.to_s.lines.size).to eq(1)
  end

  it "prints nothing if no interesting items" do
    stdin = IO::Memory.new("3\n\n-\n")
    stdout = IO::Memory.new
    Bisect::Cli.run(stdin, stdout)
    expect(stdout.to_s).to end_with("No interesting items found.\n")
  end

  it "asks to confirm the full set and the first item" do
    stdin = IO::Memory.new("3\n4\n\n+\n+\n")
    stdout = IO::Memory.new
    Bisect::Cli.run(stdin, stdout)
    expect(stdout.to_s).to end_with("The interesting item:\n3\n")
  end
end
