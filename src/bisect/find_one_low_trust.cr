module Bisect
  class FindOneLowTrust(T)
    def initialize(@items : Array(T), max_batch_size : Int32? = nil)
      @all_bounds = [] of Tuple(Int32, Int32)
      @max_batch_size = max_batch_size
    end

    def find
      indices do |left, right|
        subset = @items[left..right]
        found = yield(subset)
        if left == right && found
          return [subset.first, left + 1]
        else
          found
        end
      end

      [nil, nil]
    end

    def indices : Int32?
      size = @max_batch_size || @items.size
      return if size.zero?

      @all_bounds = (0...(@items.size / size)).map do |i|
        {i * size, Math.min((i + 1) * size, @items.size) - 1}
      end.to_a

      while (bounds = @all_bounds.shift?)
        next unless yield(bounds) # Skip uninteresting
        return bounds[0] if bounds[0] == bounds[1] # Found it!

        middle = (bounds[0] + bounds[1]) // 2
        @all_bounds = [{bounds[0], middle}, {middle + 1, bounds[1]}]
      end
    end
  end
end
