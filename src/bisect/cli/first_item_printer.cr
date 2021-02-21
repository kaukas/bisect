module Bisect
  module Cli
    module FirstItemPrinter
      def self.final_message(res)
        if res.nil?
          "No interesting items found."
        else
          "The first interesting item:\n#{res}"
        end
      end
    end
  end
end
