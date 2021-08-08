require "./find_one_low_trust"

module Bisect
  class FindOneHighTrust(T) < FindOneLowTrust(T)
    def find
      super do |subset|
        # Checking the last bound since we trust it will contain the interesting
        # item.
        @all_bounds.empty? || yield(subset)
      end
    end
  end
end
