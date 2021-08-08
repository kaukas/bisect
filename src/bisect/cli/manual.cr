module Bisect
  module Cli
    module Manual
      class ExitException < Exception; end

      def self.read_items(stdin, stdout)
        stdout.puts(
          "Enter the list of items, one per line, and an empty line at the end:"
        )
        Automatic.read_items(stdin, stdout)
      end

      def self.run(stdin, stdout, finder, printer)
        begin
          item, index = finder.find do |its|
            its = [its] unless its.is_a?(Array)

            stdout.puts(its.size > 1 ?
                        "Consider this list of items:" :
                        "Consider this item:")
            its.each { |it| stdout.puts(it) }
            stdout.puts
            stdout.print(its.size > 1 ?
                         "Are they interesting? " :
                         "Is it interesting? ")

            line = ""
            until ["+", "-"].includes?(line)
              stdout.print("Enter + or -: ")
              line = stdin.gets
              raise ExitException.new if line.nil?
            end
            line == "+"
          end

          stdout.puts(printer.final_message(item, index))
        rescue ExitException
        end
      end
    end
  end
end
