require "../bisect"

module Bisect
  module Cli
    class ExitException < Exception; end

    def self.run(stdin, stdout)
      stdout.puts(
        "Enter the list of items, one per line, and an empty line at the end:"
      )
      items = [] of String
      line = stdin.gets
      while line && !line.empty?
        items << line.strip
        line = stdin.gets
      end
      return if items.empty?

      begin
        res = Bisect::One.new(items).find do |its|
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
