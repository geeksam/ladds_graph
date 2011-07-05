require 'graph'
require 'set'

class Map < Graph
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
    attr_reader :unique_streets, :backtracked_streets, :start, :finish
    
    def initialize(*args)
      super(*args)
      @start = @finish = current_node
      @unique_streets      = Set.new
      @backtracked_streets = Set.new
    end
    def initialize_copy(original)
      super
      @unique_streets      = original.unique_streets.dup
      @backtracked_streets = original.backtracked_streets.dup
    end
    
    def inspect
      node = start
      nodes = [node]
      segments.each do |edge|
        node = edge.other_node(node)
        nodes << node
      end
      '<Path (%d edges, %d points) %s>' % [segments.length, score, nodes.join(', ')]
    end
    
    def traverse(edge)
      super(edge)
      @score = nil
      @finish = current_node
      case
      when edge.points == 0
        # don't care how many times we traverse borders
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

    DefaultDFSOptions = {
      :max_path_length => 2,
      :backtrack_avoidance_factor => 3,
      :persistence_factor => 4,
    }

    class DfsCounter
      attr_reader :count
      def initialize
        @count = 0
      end
      def increment!
        @count += 1
      end
    end

    def dfs_counter
      @dfs_counter ||= DfsCounter.new
    end

    def go_forth_and_multiply(options = {}, interesting_paths = {})
# puts self.inspect if options[:trace_recursion]
      dfs_counter.increment!
      options = DefaultDFSOptions.merge(options)

      # Keep us updated from time to time
      if options[:debug_every_n_steps] && (dfs_counter.count % options[:debug_every_n_steps]).zero?
        puts "\n\nAfter %d steps, current path list is:\n%s" % [
          dfs_counter.count,
          interesting_paths.to_a.sort.map { |e| e.last.inspect }.join("\n"),
        ]
      end

      # Respect the max_path_length setting
      return unless segments.length < options[:max_path_length]
      
      # ditto the max_backtrack_count setting
      return if backtracked_streets.length > options[:max_backtrack_count]

      # Don't go any further if we haven't improved our score over the past N segments
      last_n_segments = segments.last_n(options[:persistence_factor])
      return unless last_n_segments.empty? || last_n_segments.sum(&:points) > 0
      
      # Don't consider backtracking across the last N segments
      candidates = available_edges - segments.last_n(options[:backtrack_avoidance_factor])

      # Keep on truckin'
      candidates.each do |edge|
        child = self.clone
        child.traverse(edge)
        if child.is_circuit? && child.score > 0
          existing_path_for_score = interesting_paths[child.score]
          if existing_path_for_score.nil? || child.length < existing_path_for_score.length
            interesting_paths[child.score] = child
          end
        end
        child.go_forth_and_multiply(options, interesting_paths)
      end

      return interesting_paths
    end
  end
end
