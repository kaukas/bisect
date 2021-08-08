module Bisect
  class FindFirstLowTrust(T)
    def initialize(@items : Array(T))
    end

    def find
      index = indices do |index|
        yield(@items[index])
      end

      index ? [@items[index], index + 1] : [nil, nil]
    end

    def indices : Int32?
      return if @items.size.zero?
      return 0 if yield(0)
      return if !yield(@items.size - 1)

      bounds = {0, @items.size - 1}

      loop do
        middle = (bounds[0] + bounds[1]) // 2
        return bounds[1] if bounds[0] == middle

        bounds = yield(middle) ? {bounds[0], middle} : {middle, bounds[1]}
      end

      nil
    end
  end
end
