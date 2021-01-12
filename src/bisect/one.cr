module Bisect
  class One(T)
    def initialize(@items : Array(T))
    end

    def find(&block : Array(T) -> Bool) : T?
      indices do |left, right|
        subset = @items[left...right]
        found = block.call(subset)
        if right - left == 1 && found
          return subset.first
        else
          found
        end
      end

      nil
    end

    private def indices
      bounds = {0, @items.size}
      other = nil
      while bounds[1] > bounds[0]
        found = yield(bounds)
        if found
          middle = (bounds[0] + bounds[1]) // 2
          other = {middle, bounds[1]}
          bounds = {bounds[0], middle}
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
