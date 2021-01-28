require "option_parser"

require "./cli/automatic"
require "./cli/manual"

module Bisect
  module Cli
    def self.run(stdin, stdout, argv)
      help = false
      cmd = [] of String

      OptionParser.parse(argv) do |parser|
        parser.banner = "Usage: bisect <options> [-- verifier-command]"

        parser.on("-h", "--help", "Show this help message") do
          help = true
          stdout.puts(parser)
        end

        parser.unknown_args do |_, after_dash|
          cmd = after_dash
        end
      end

      return if help

      if cmd.empty?
        Cli::Manual.run(stdin, stdout)
      else
        Cli::Automatic.run(stdin, stdout, cmd)
      end
    end
  end
end
