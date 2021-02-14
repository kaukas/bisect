require "../../bisect"

module Bisect
  module Cli
    module Manual
      class ExitException < Exception; end

      def self.run(stdin, stdout, strategy_cls)
        stdout.puts(
          "Enter the list of items, one per line, and an empty line at the end:"
        )
        items = Iterator.of { stdin.gets }.
          take_while { |line| line && !line.empty? }.
          to_a
        return if items.empty?

        begin
          res = Bisect::One.find(strategy_cls, items) do |its|
            stdout.puts("Consider this list of items:")
            its.each { |it| stdout.puts(it) }
            stdout.puts
            stdout.print("Are they interesting? ")

            line = ""
            until ["+", "-"].includes?(line)
              stdout.print("Enter + or -: ")
              line = stdin.gets
              raise ExitException.new if line.nil?
            end
            line == "+"
          end

          if res.nil?
            stdout.puts("No interesting items found.")
          else
            stdout.puts("The interesting item:")
            stdout.puts(res)
          end
        rescue ExitException
        end
      end
    end
  end
end
