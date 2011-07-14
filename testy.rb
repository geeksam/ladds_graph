$: << File.expand_path(File.join(File.dirname(__FILE__), *%w[lib]))

require 'graph'
require 'map'
require 'ladds_graph'

path = Ladds.path(42)

puts "Max backtracks\tAvoidance factor\tPersistence factor\tBest score\tBest path"

(10..20).each do |max_backtracks|
  (1..7).each do |avoidance|
    (3..8).each do |persistence|
      path.dfs_counter.reset!
      opts = {
        :max_backtrack_count        => max_backtracks,
        :backtrack_avoidance_factor => avoidance,
        :persistence_factor         => persistence,
      }
      paths = path.go_forth_and_multiply(opts.merge({
        :stop_after_n_iterations => 50_000,
        :max_path_length         => 200,
      }))
      best_path = paths.to_a.sort.last.last
      puts [ max_backtracks, avoidance, persistence, best_path.score, best_path.inspect ].join("\t")
    end
  end
end
