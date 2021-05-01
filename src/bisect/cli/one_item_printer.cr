module Bisect
  module Cli
    module OneItemPrinter
      def self.final_message(item, index)
        if item.nil?
          "No interesting items found."
        else
          "The interesting item:\n#{item}\nAt line #{index}"
        end
      end
    end
  end
end
