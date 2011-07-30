############### PATHS ###############
class Graph
  def path(starting_node)
    Path.new(self, starting_node)
  end

  UnreachableNode = Class.new(Exception)
  UnreachableEdge = Class.new(Exception)
  class Path
    attr_reader :graph, :segments, :current_node

    def initialize(graph, starting_node)
      @graph = graph
      @segments ||= []
      @current_node = starting_node
    end
    def initialize_copy(original)
      @segments = original.segments.dup
    end
    
    def length; segments.length; end
    def head;   segments.first;  end
    def tail;   segments.last;   end

    def traverse(edge)
      raise UnreachableNode if edge.nil?
      raise UnreachableEdge if tail && !tail.adjacent_to?(edge)
      segments << edge
      @current_node = edge - @current_node
    end

    def available_edges
      graph.edges_for(current_node).dup
    end

    def travel_to(*nodes)
      nodes.flatten!
      @current_node ||= nodes.shift
      nodes.each do |node|
        edge = available_edges.detect { |edge| edge.connects_to?(node) }
        traverse edge
      end
    end
  end
end
