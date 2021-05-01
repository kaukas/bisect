require "option_parser"

require "./find_first_low_trust"
require "./find_first_high_trust"
require "./find_one_low_trust"
require "./find_one_high_trust"
require "./find_last_low_trust"
require "./find_last_high_trust"

require "./cli/automatic"
require "./cli/manual"
require "./cli/one_item_printer"
require "./cli/first_item_printer"
require "./cli/last_item_printer"

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

      mode_cls, printer_cls = case [mode, trust]
                              when [Mode::One, Trust::Low]
                                {FindOneLowTrust, OneItemPrinter}
                              when [Mode::One, Trust::High]
                                {FindOneHighTrust, OneItemPrinter}
                              when [Mode::First, Trust::Low]
                                {FindFirstLowTrust, FirstItemPrinter}
                              when [Mode::First, Trust::High]
                                {FindFirstHighTrust, FirstItemPrinter}
                              when [Mode::Last, Trust::Low]
                                {FindLastLowTrust, LastItemPrinter}
                              when [Mode::Last, Trust::High]
                                {FindLastHighTrust, LastItemPrinter}
                              else
                                raise "Unknown mode #{mode} and trust #{trust}"
                              end
      if cmd.empty?
        Cli::Manual.run(stdin, stdout, mode_cls, printer_cls)
      else
        Cli::Automatic.run(stdin, stdout, cmd, mode_cls, printer_cls)
      end
    end
  end
end
