require "option_parser"

require "./no_trust_strategy"
require "./trust_strategy"
require "./cli/automatic"
require "./cli/manual"

module Bisect
  module Cli
    def self.run(stdin, stdout, argv)
      help = false
      strategy_cls = NoTrustStrategy
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
          strategy_cls = TrustStrategy
        end

        parser.unknown_args do |_, after_dash|
          cmd = after_dash
        end
      end

      return if help

      if cmd.empty?
        Cli::Manual.run(stdin, stdout, strategy_cls)
      else
        Cli::Automatic.run(stdin, stdout, cmd, strategy_cls)
      end
    end
  end
end
