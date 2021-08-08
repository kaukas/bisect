require "./find_first_low_trust"

module Bisect
  class FindFirstHighTrust(T) < FindFirstLowTrust(T)
    def indices : Int32 | Nil
      # Assume the right boundary to always be interesting.
      emitted = 0
      super do |index|
        emitted += 1
        emitted == 2 ? true : yield(index)
      end
    end
  end
end
