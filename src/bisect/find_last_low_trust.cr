require "./find_first_low_trust"

module Bisect
  class FindLastLowTrust(T) < FindFirstLowTrust(T)
    def indices : Int32 | Nil
      size = @items.size
      return if size.zero?
      return if !yield(0)
      return size - 1 if yield(size - 1)

      bounds = {0, size - 1}

      loop do
        middle = (bounds[0] + bounds[1]) // 2
        return bounds[0] if bounds[0] == middle

        bounds = yield(middle) ? {middle, bounds[1]} : {bounds[0], middle}
      end

      nil
    end
  end
end
