module Bisect
  module Cli
    module Automatic
      def self.run(stdin, stdout, cmd, strategy, printer)
        items = Iterator.of { stdin.gets }.
          take_while { |line| line && !line.empty? }.
          to_a
        return if items.empty?

        res = strategy.find(items) do |its|
          its = [its] unless its.is_a?(Array)

          input = IO::Memory.new(its.join("\n"))
          success = Process.run(cmd[0],
                                cmd[1..],
                                input: input,
                                error: Process::Redirect::Inherit
          ).success?
          !success
        end

        stdout.puts(printer.final_message(res))
      end
    end
  end
end
