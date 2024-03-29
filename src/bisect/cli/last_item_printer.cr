module Bisect
  module Cli
    module LastItemPrinter
      def self.final_message(item, index)
        if item.nil?
          "No interesting items found."
        else
          "The last interesting item:\n#{item}\nAt line #{index}"
        end
      end
    end
  end
end
