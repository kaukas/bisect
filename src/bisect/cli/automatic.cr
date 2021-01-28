require "../../bisect"

module Bisect
  module Cli
    module Automatic
      def self.run(stdin, stdout, cmd)
        items = Iterator.of { stdin.gets }.
          take_while { |line| line && !line.empty? }.
          to_a
        return if items.empty?

        res = Bisect::One.new(items).find do |its|
          input = IO::Memory.new(its.join("\n"))
          success = Process.run(cmd[0],
                                cmd[1..],
                                input: input,
                                error: Process::Redirect::Inherit
          ).success?
          !success
        end

        if res.nil?
          stdout.puts("No interesting items found.")
        else
          stdout.puts("The interesting item:")
          stdout.puts(res)
        end
      end
    end
  end
end
