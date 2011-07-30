require 'graph'
require 'set'

class Map < Graph
  attr_accessor :starting_and_ending_nodes

  alias :streets :edges
  def street(n1, n2)
    edge(n1, n2, 1)
  end
  def border(n1, n2)
    edge(n1, n2, 0)
  end

  def path(starting_node)
    MapPath.new(self, starting_node)
  end

  class MapPath < Graph::Path
    attr_reader :unique_streets, :backtracked_streets, :border_streets, :start, :finish
    
    def initialize(*args)
      super(*args)
      @start = @finish = current_node
      @unique_streets      = Set.new
      @backtracked_streets = Set.new
      @border_streets      = Set.new
    end
    def initialize_copy(original)
      super
      @unique_streets      = original.unique_streets.dup
      @backtracked_streets = original.backtracked_streets.dup
    end
    
    def inspect
      node = start
      nodes = []
      segments.each do |edge|
        nodes << node
        node = edge - node
      end
      '<Path (%d edges, %d uniques, %d backtracks, %d borders, %d points) %s>' % [
        segments.length,
        unique_streets.length,
        backtracked_streets.length,
        border_streets.length,
        score,
        nodes.join(', '),
      ]
    end
    
    def traverse(edge)
      super(edge)
      @score = nil
      @finish = current_node
      case
      when edge.points == 0
        # don't care how many times we traverse borders, but count 'em anyway
        border_streets.add(edge)
      when unique_streets.include?(edge)
        # first backtracking:  move the street from the positive set to the negative set
        unique_streets.delete(edge)
        backtracked_streets.add(edge)
      when backtracked_streets.include?(edge)
        # subsequent backtrackings need no further bookkeeping
      else
        # first traversal:  add the street to the positive set
        unique_streets.add(edge)
      end
    end
    
    def score
      @score ||= unique_streets.length - backtracked_streets.length
    end

    def is_circuit?
      return false if segments.empty?
      graph.starting_and_ending_nodes.include?(start) && graph.starting_and_ending_nodes.include?(finish)
    end
  end
end
