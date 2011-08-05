require 'map'

class Map < Graph
  class MapPath < Graph::Path
    attr_reader :unique_streets, :backtracked_streets, :border_streets, :start, :finish
    
    DefaultDFSOptions = {
      :max_path_length            => 2,
      :backtrack_avoidance_factor => 3,
      :persistence_factor         => 4,
      :max_backtrack_count        => 7,
    }

    class DfsCounter
      attr_reader :count
      def initialize
        @count = 0
      end
      def increment!
        @count += 1
      end
      def reset!
        @count = 0
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

      # die early if instructed to
      return if options[:stop_after_n_iterations] && dfs_counter.count > options[:stop_after_n_iterations].to_i

      # Respect the max_path_length setting
      return unless segments.length < options[:max_path_length]

      # ditto the max_backtrack_count setting
      return if backtracked_streets.length > options[:max_backtrack_count]

      # Don't go any further if we haven't improved our score over the past N segments
      last_n_segments = segments.last_n(options[:persistence_factor])
      return unless last_n_segments.empty? || last_n_segments.sum(&:points) > 0

      # Don't consider backtracking across the last N segments
      candidates = available_edges - segments.last_n(options[:backtrack_avoidance_factor])

      # Randomize?
      candidates.shuffle! if options[:randomize]

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