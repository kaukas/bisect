require "../find_one_low_trust"
require "../find_one_high_trust"
require "../find_first_low_trust"
require "../find_first_high_trust"
require "../find_last_low_trust"
require "../find_last_high_trust"

require "./one_item_printer"
require "./first_item_printer"
require "./last_item_printer"

module Bisect
  module Cli
    module FinderPicker
      def self.pick_finder(mode, trust, items)
        case [mode, trust]
        when [Mode::One, Trust::Low]
          {FindOneLowTrust.new(items), OneItemPrinter}
        when [Mode::One, Trust::High]
          {FindOneHighTrust.new(items), OneItemPrinter}
        when [Mode::First, Trust::Low]
          {FindFirstLowTrust.new(items), FirstItemPrinter}
        when [Mode::First, Trust::High]
          {FindFirstHighTrust.new(items), FirstItemPrinter}
        when [Mode::Last, Trust::Low]
          {FindLastLowTrust.new(items), LastItemPrinter}
        when [Mode::Last, Trust::High]
          {FindLastHighTrust.new(items), LastItemPrinter}
        else
          raise "Unknown mode #{mode} and trust #{trust}"
        end
      end
    end
  end
end
