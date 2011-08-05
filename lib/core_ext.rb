# Object#tap
unless Object.new.respond_to?(:tap)
  class Object
    def tap
      yield self
      return self
    end
  end
end

# Enumerable#sum
unless [].respond_to?(:sum)
  module Enumerable
    def sum(initial_value = 0)
      inject(initial_value) do |mem, var|
        var = yield(var) if block_given?
        mem + var
      end
    end
  end
end

# Array#last_n
unless Array.new.respond_to?(:last_n)
  class Array
    def last_n(n)
      n = [n, length].min
      Array(slice(-1*n, n))
    end
  end
end

unless 42.respond_to?(:positive?)
  class Fixnum
    def positive?
      self > 0
    end
    def negative?
      self < 0
    end
  end
end

unless 42.0.respond_to?(:to_degrees)
  class Float
    def to_degrees
      self.to_f * 180 / Math::PI
    end
  end
end
