require "./finder_picker"

module Bisect
  module Cli
    module Automatic
      def self.run(stdin, stdout, cmd, mode, trust)
        items = Iterator.of { stdin.gets }.
          take_while { |line| line && !line.empty? }.
          to_a
        return if items.empty?

        finder, printer = FinderPicker.pick_finder(mode, trust, items)
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
