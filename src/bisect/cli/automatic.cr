module Bisect
  module Cli
    module Automatic
      def self.read_items(stdin, _stdout)
        Iterator.of { stdin.gets }.
          take_while { |line| line && !line.empty? }.
          to_a
      end

      def self.run(_stdin, stdout, cmd, finder, printer)
        item, index = finder.find do |its|
          its = [its] unless its.is_a?(Array)

          input = IO::Memory.new(its.join("\n"))
          success = Process.run(cmd[0],
                                cmd[1..],
                                input: input,
                                error: Process::Redirect::Inherit
          ).success?
          !success
        end

        stdout.puts(printer.final_message(item, index))
      end
    end
  end
end
