require "./find_one_low_trust"

module Bisect
  class FindOneHighTrust < FindOneLowTrust
    def self.find(items)
      deduced : Bool | Nil = true
      super(items) do |subset|
        if deduced.nil?
          interesting = yield(subset)
          deduced = true if !interesting
        else
          interesting, deduced = deduced, nil
        end
        interesting
      end
    end
  end
end
