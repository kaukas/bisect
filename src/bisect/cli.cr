require "option_parser"

require "./find_one_low_trust"
require "./find_one_high_trust"
require "./find_first_low_trust"
require "./find_first_high_trust"
require "./find_last_low_trust"
require "./find_last_high_trust"

require "./cli/one_item_printer"
require "./cli/first_item_printer"
require "./cli/last_item_printer"
require "./cli/automatic"
require "./cli/manual"

module Bisect
  module Cli
    enum Mode
      One
      First
      Last
    end

    enum Trust
      Low
      High
    end

    def self.run(stdin, stdout, argv)
      help = false
      max_batch_size = nil
      mode = Mode::One
      trust = Trust::Low
      cmd = [] of String

      OptionParser.parse(argv) do |parser|
        parser.banner = "Usage: bisect <options> [-- verifier-command]"

        parser.on("-h", "--help", "Show this help message.") do
          help = true
          stdout.puts(parser)
        end

        parser.on(
          "--max-batch-size=MAX_BATCH_SIZE",
          "Maximum size of the batch to confirm. Unlimited by default."
        ) do |s|
          max_batch_size = s.to_i
        end

        parser.on(
          "-t",
          "--trust",
          "Assume that interesting items are present. For mode 'one' assume " \
          "there is only one interesting item present."
        ) do
          trust = Trust::High
        end

        parser.on(
          "-m MODE",
          "--mode MODE",
          "Search mode, one of [one, first, last]. Default: 'one'.") do |m|
          mode = case m
                 when "one"
                   Mode::One
                 when "first"
                   Mode::First
                 when "last"
                   Mode::Last
                 else
                   puts("Unknown mode '#{m}'. " \
                        "Please specify one of [one, first, last].")
                   exit(1)
                 end
        end

        parser.unknown_args do |_, after_dash|
          cmd = after_dash
        end
      end

      return if help

      items = if cmd.empty?
                Cli::Manual.read_items(stdin, stdout)
              else
                Cli::Automatic.read_items(stdin, stdout)
              end
      return if items.empty?

      finder = pick_finder(mode, trust, max_batch_size, items)
      printer = pick_printer(mode)

      if cmd.empty?
        Cli::Manual.run(stdin, stdout, finder, printer)
      else
        Cli::Automatic.run(stdin, stdout, cmd, finder, printer)
      end
    end

    def self.pick_finder(mode, trust, max_batch_size, items)
      case [mode, trust]
      when [Mode::One, Trust::Low]
        FindOneLowTrust.new(items, max_batch_size)
      when [Mode::One, Trust::High]
        FindOneHighTrust.new(items, max_batch_size)
      when [Mode::First, Trust::Low]
        FindFirstLowTrust.new(items)
      when [Mode::First, Trust::High]
        FindFirstHighTrust.new(items)
      when [Mode::Last, Trust::Low]
        FindLastLowTrust.new(items)
      when [Mode::Last, Trust::High]
        FindLastHighTrust.new(items)
      else
        raise "Unknown mode #{mode} and trust #{trust}"
      end
    end

    def self.pick_printer(mode)
      case mode
      when Mode::One
        OneItemPrinter
      when Mode::First
        FirstItemPrinter
      when Mode::Last
        LastItemPrinter
      else
        raise "Unknown mode #{mode}"
      end
    end
  end
end
