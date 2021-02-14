require "./indices"

module Bisect
  class NoTrustStrategy
    def self.find(items)
      Indices.find(items.size) do |left, right|
        subset = items[left..right]
        found = yield(subset)
        if left == right && found
          return subset.first
        else
          found
        end
      end

      nil
    end
  end
end
