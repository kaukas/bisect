require "option_parser"

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

      if cmd.empty?
        Cli::Manual.run(stdin, stdout, mode, trust)
      else
        Cli::Automatic.run(stdin, stdout, cmd, mode, trust)
      end
    end
  end
end
