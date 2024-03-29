require "./find_last_low_trust"

module Bisect
  class FindLastHighTrust(T) < FindLastLowTrust(T)
    def indices : Int32 | Nil
      # Assume the left boundary to always be interesting.
      emitted = 0
      super do |index|
        emitted += 1
        emitted == 1 ? true : yield(index)
      end
    end
  end
end
