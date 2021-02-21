module Bisect
  class FindFirstLowTrust
    def self.find(items)
      index = indices(items.size) do |index|
        yield(items[index])
      end

      index ? items[index] : nil
    end

    def self.indices(size) : Int32 | Nil
      return if size.zero?
      return 0 if yield(0)
      return if !yield(size - 1)

      bounds = {0, size - 1}

      loop do
        middle = (bounds[0] + bounds[1]) // 2
        return bounds[1] if bounds[0] == middle

        bounds = yield(middle) ? {bounds[0], middle} : {middle, bounds[1]}
      end

      nil
    end
  end
end
