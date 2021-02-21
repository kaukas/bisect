module Bisect
  class FindOneLowTrust
    def self.find(items)
      indices(items.size) do |left, right|
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

    def self.indices(size) : Int32 | Nil
      return if size.zero?

      bounds = {0, size - 1}
      other = nil
      loop do
        interesting = yield(bounds)
        if interesting
          if bounds[0] == bounds[1]
            return bounds[0]
          else
            middle = (bounds[0] + bounds[1]) // 2
            other = {middle + 1, bounds[1]}
            bounds = {bounds[0], middle}
          end
        else
          if other.nil?
            # Perhaps the checking block is impure and changed its mind. Or
            # perhaps it depends on more than one item so no one item satisfies
            # it.
            return
          else
            bounds, other = other, nil
          end
        end
      end
    end
  end
end
