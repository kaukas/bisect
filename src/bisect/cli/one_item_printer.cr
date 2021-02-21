module Bisect
  module Cli
    module OneItemPrinter
      def self.final_message(res)
        if res.nil?
          "No interesting items found."
        else
          "The interesting item:\n#{res}"
        end
      end
    end
  end
end
