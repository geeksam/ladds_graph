require 'graph'
require 'set'

class Map < Graph
  attr_accessor :starting_and_ending_nodes, :coordinates, :scaling_factor

  alias :streets :edges
  def street(n1, n2)
    edge(n1, n2, 1)
  end
  def border(n1, n2)
    edge(n1, n2, 0)
  end
  def XY(n, pair = nil)
    if pair
      @coordinates[n] = pair
    else
      @coordinates[n]
    end
  end

  def initialize(*args)
    super
    @coordinates = Hash.new
    @scaling_factor = 1
  end

  def path(starting_node)
    MapPath.new(self, starting_node)
  end

  def distance_of(edge)
    a, b = *edge.endpoints
    distance_between_nodes(a, b)
  end

  def distance_between_nodes(n1, n2)
    ax, ay = *XY(n1)
    bx, by = *XY(n2)
    rise = (ax - bx).abs
    run  = (ay - by).abs

    distance = case
    when rise.zero? then run
    when run .zero? then rise
    else Math.hypot(rise, run)
    end

    distance * scaling_factor
  end

  def direction(n1, n2)
    case angle_between(n1, n2)
    when (  0.0 ..  22.5) then :E
    when ( 22.5 ..  67.5) then :NE
    when ( 67.5 .. 112.5) then :N
    when (112.5 .. 157.5) then :NW
    when (157.5 .. 202.5) then :W
    when (202.5 .. 247.5) then :SW
    when (247.5 .. 292.5) then :S
    when (292.5 .. 337.5) then :SE
    when (  0.0 .. 337.5) then :E
    end
  end

  def angle_between(n1, n2)
    ax, ay = *XY(n1)
    bx, by = *XY(n2)
    x_dist = bx - ax
    y_dist = by - ay

    # A few shortcuts
    return  90 if x_dist.zero? && y_dist.positive?
    return 180 if y_dist.zero? && x_dist.negative?
    return 270 if x_dist.zero? && y_dist.negative?

    hyp = Math.hypot(x_dist, y_dist)

    if y_dist >= 0
      sin = Math.asin(y_dist / hyp)
      if x_dist >= 0  # Q1:  Any (so use sine)
        return  0 + sin.to_degrees
      else            # Q2:  Sine
        return 90 + sin.to_degrees
      end
    else
      if x_dist < 0   # Q3:  Tangent
        tan = Math.atan(y_dist / x_dist)
        return 180 + tan.to_degrees
      else            # Q4:  Cosine
        cos = Math.acos(x_dist / hyp)
        return 270 + cos.to_degrees
      end
    end
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

    def distance
      segments.inject(0) { |mem, edge|
        mem + @graph.distance_of(edge)
      }
    end

    def is_circuit?
      return false if segments.empty?
      graph.starting_and_ending_nodes.include?(start) && graph.starting_and_ending_nodes.include?(finish)
    end
  end
end
