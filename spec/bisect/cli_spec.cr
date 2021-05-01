require "../spec_helper"
require "../../src/bisect/cli"

Spectator.describe Bisect::Cli do
  describe "help" do
    it "prints help on -h" do
      stdin = IO::Memory.new
      stdout = IO::Memory.new
      Bisect::Cli.run(stdin, stdout, ["-h"])
      expect(stdout.to_s.lines[0]).to start_with("Usage")
    end

    it "prints help on --help" do
      stdin = IO::Memory.new
      stdout = IO::Memory.new
      Bisect::Cli.run(stdin, stdout, ["--help"])
      expect(stdout.to_s.lines[0]).to start_with("Usage")
    end
  end

  describe "no arguments" do
    it "asks to confirm and prints the interesting item" do
      stdin = IO::Memory.new("3\n4\n\n+\n-\n+\n")
      stdout = IO::Memory.new
      Bisect::Cli.run(stdin, stdout, [] of String)
      expect(stdout.to_s.lines).to eq([
        "Enter the list of items, one per line, and an empty line at the end:",
        "Consider this list of items:",
        "3",
        "4",
        "",
        "Are they interesting? Enter + or -: Consider this item:",
        "3",
        "",
        "Is it interesting? Enter + or -: Consider this item:",
        "4",
        "",
        "Is it interesting? Enter + or -: The interesting item:",
        "4",
        "At line 2"
      ])
    end

    it "prints nothing if no items" do
      stdin = IO::Memory.new("")
      stdout = IO::Memory.new
      Bisect::Cli.run(stdin, stdout, [] of String)
      expect(stdout.to_s.lines.size).to eq(1)
    end

    it "prints nothing if no interesting items" do
      stdin = IO::Memory.new("3\n\n-\n")
      stdout = IO::Memory.new
      Bisect::Cli.run(stdin, stdout, [] of String)
      expect(stdout.to_s).to end_with("No interesting items found.\n")
    end

    it "asks to confirm the full set and the first item" do
      stdin = IO::Memory.new("3\n4\n\n+\n+\n")
      stdout = IO::Memory.new
      Bisect::Cli.run(stdin, stdout, [] of String)
      expect(stdout.to_s).to end_with("The interesting item:\n3\nAt line 1\n")
    end
  end

  describe "with checking command" do
    it "runs the command to find the interesting item" do
      stdin = IO::Memory.new("3\n4\n")
      stdout = IO::Memory.new
      Bisect::Cli.run(stdin, stdout, ["--", "bash", "-c", "! grep 4"])
      expect(stdout.to_s).to eq("The interesting item:\n4\nAt line 2\n")
    end
  end

  describe "with trust" do
    it "assumes the only item is interesting" do
      stdin = IO::Memory.new("3\n\n")
      stdout = IO::Memory.new
      Bisect::Cli.run(stdin, stdout, ["--trust"])
      expect(stdout.to_s.lines).to eq([
        "Enter the list of items, one per line, and an empty line at the end:",
        "The interesting item:",
        "3",
        "At line 1"
      ])
    end
  end

  describe "first mode" do
    it "asks to confirm one item at a time" do
      stdin = IO::Memory.new("3\n4\n\n-\n+\n")
      stdout = IO::Memory.new
      Bisect::Cli.run(stdin, stdout, ["--mode", "first"])
      expect(stdout.to_s.lines).to eq([
        "Enter the list of items, one per line, and an empty line at the end:",
        "Consider this item:",
        "3",
        "",
        "Is it interesting? Enter + or -: Consider this item:",
        "4",
        "",
        "Is it interesting? Enter + or -: " \
        "The first interesting item:",
        "4",
        "At line 2",
      ])
    end

    it "skips confirmation of the last item in high trust" do
      stdin = IO::Memory.new("3\n4\n\n-\n")
      stdout = IO::Memory.new
      Bisect::Cli.run(stdin, stdout, ["--mode", "first", "--trust"])
      expect(stdout.to_s.lines).to eq([
        "Enter the list of items, one per line, and an empty line at the end:",
        "Consider this item:",
        "3",
        "",
        "Is it interesting? Enter + or -: " \
        "The first interesting item:",
        "4",
        "At line 2"
      ])
    end
  end

  describe "last mode" do
    it "asks to confirm one item at a time" do
      stdin = IO::Memory.new("3\n4\n\n+\n+\n")
      stdout = IO::Memory.new
      Bisect::Cli.run(stdin, stdout, ["--mode", "last"])
      expect(stdout.to_s.lines).to eq([
        "Enter the list of items, one per line, and an empty line at the end:",
        "Consider this item:",
        "3",
        "",
        "Is it interesting? Enter + or -: Consider this item:",
        "4",
        "",
        "Is it interesting? Enter + or -: The last interesting item:",
        "4",
        "At line 2"
      ])
    end

    it "skips confirmation of the first item in high trust" do
      stdin = IO::Memory.new("3\n4\n\n+\n")
      stdout = IO::Memory.new
      Bisect::Cli.run(stdin, stdout, ["--mode", "last", "--trust"])
      expect(stdout.to_s.lines).to eq([
        "Enter the list of items, one per line, and an empty line at the end:",
        "Consider this item:",
        "4",
        "",
        "Is it interesting? Enter + or -: The last interesting item:",
        "4",
        "At line 2"
      ])
    end
  end
end
