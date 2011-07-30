class Graph
  Edge = Struct.new(:n1, :n2, :points) do
    def to_s
      "%s:%s (%d)" % [n1, n2, points]
    end
    def inspect
      "<Edge: %s ~ %s>" % [n1, n2]
    end

    def adjacent_to?(other_edge)
      self.n1 == other_edge.n1 || 
      self.n1 == other_edge.n2 || 
      self.n2 == other_edge.n1 || 
      self.n2 == other_edge.n2
    end
    
    def connects_to?(node)
      n1 == node || n2 == node
    end

    def endpoints
      [n1, n2]
    end

    def other_node(this_node)
      raise "wtf?" unless endpoints.include?(this_node)
      (endpoints - [this_node]).first
    end
    alias :- :other_node
  end
end
