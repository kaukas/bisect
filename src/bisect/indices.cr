module Bisect
  module Indices
    def self.find(size) : Int32 | Nil
      return if size.zero?

      bounds = {0, size - 1}
      other = nil
      loop do
        found = yield(bounds)
        if found
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
