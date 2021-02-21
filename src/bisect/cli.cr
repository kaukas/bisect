require "option_parser"

require "./cli/automatic"
require "./cli/manual"
require "./cli/one_item_printer"
require "./cli/first_item_printer"

require "./find_first_high_trust"
require "./find_first_low_trust"
require "./find_one_high_trust"
require "./find_one_low_trust"

module Bisect
  module Cli
    enum Mode
      One
      First
    end

    enum Trust
      Low
      High
    end

    def self.run(stdin, stdout, argv)
      help = false
      mode = Mode::One
      trust = Trust::Low
      cmd = [] of String

      OptionParser.parse(argv) do |parser|
        parser.banner = "Usage: bisect <options> [-- verifier-command]"

        parser.on("-h", "--help", "Show this help message") do
          help = true
          stdout.puts(parser)
        end

        parser.on(
          "-t",
          "--trust",
          "Assume that there is always one and only one interesting item"
        ) do
          trust = Trust::High
        end

        parser.on(
          "-m MODE",
          "--mode MODE",
          "Search mode, one of: [one, first]. Default: one") do |m|
          mode = Mode::First
        end

        parser.unknown_args do |_, after_dash|
          cmd = after_dash
        end
      end

      return if help

      strategy, printer = case [mode, trust]
                          when [Mode::One, Trust::Low]
                            {FindOneLowTrust, OneItemPrinter}
                          when [Mode::One, Trust::High]
                            {FindOneHighTrust, OneItemPrinter}
                          when [Mode::First, Trust::Low]
                            {FindFirstLowTrust, FirstItemPrinter}
                          when [Mode::First, Trust::High]
                            {FindFirstHighTrust, FirstItemPrinter}
                          else
                            raise "Unknown mode and trust"
                          end
      if cmd.empty?
        Cli::Manual.run(stdin, stdout, strategy, printer)
      else
        Cli::Automatic.run(stdin, stdout, cmd, strategy, printer)
      end
    end
  end
end
