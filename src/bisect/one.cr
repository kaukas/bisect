require "./no_trust_strategy"

module Bisect
  class One
    def self.find(strategy, items)
      strategy.find(items) { |subset| yield(subset) }
    end
  end
end
