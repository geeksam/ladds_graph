require 'core_ext'


############### GRAPH ###############
class Graph
  attr_accessor :starting_and_ending_nodes

  def adjacency_hash
    @adjacency_hash ||= Hash.new { |hash, key| hash[key] = [] }
  end

  def edges_for(node)
    adjacency_hash[node]
  end

  def edges
    @edges ||= []
  end
  
  def edge(*attrs)
    Edge.new(*attrs).tap do |e|
      adjacency_hash[e.n1] << e
      adjacency_hash[e.n2] << e
      edges << e
    end
  end
end


############### EDGES ###############
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

    def other_node(this_node)
      case this_node
      when n1 then n2
      when n2 then n1
      end
    end
  end
end


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
    
    def length; @segments.length; end
    def head;   @segments.first;  end
    def tail;   @segments.last;   end

    def traverse(edge)
      raise UnreachableEdge if tail && !tail.adjacent_to?(edge)
      segments << edge
      @current_node = edge.other_node(@current_node)
    end

    def available_edges
      @graph.edges_for(@current_node).dup
    end

    def travel_to(*nodes)
      nodes.flatten!
      @current_node ||= nodes.shift
      nodes.each do |node|
        edge = available_edges.detect { |edge| edge.connects_to?(node) }
        raise UnreachableNode if edge.nil?
        traverse edge
      end
    end
  end
end
