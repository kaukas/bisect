require "./find_last_low_trust"

module Bisect
  class FindLastHighTrust < FindLastLowTrust
    def self.indices(size) : Int32 | Nil
      # Assume the left boundary to always be interesting.
      emitted = 0
      super(size) do |index|
        emitted += 1
        emitted == 1 ? true : yield(index)
      end
    end
  end
end
