module Bisect
  module Cli
    module FirstItemPrinter
      def self.final_message(item, index)
        if item.nil?
          "No interesting items found."
        else
          "The first interesting item:\n#{item}\nAt line #{index}"
        end
      end
    end
  end
end
