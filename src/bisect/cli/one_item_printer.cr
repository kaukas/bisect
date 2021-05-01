module Bisect
  module Cli
    module OneItemPrinter
      def self.final_message(item, index)
        if item.nil?
          "No interesting items found."
        else
          "The interesting item at line #{index}:\n#{item}"
        end
      end
    end
  end
end
