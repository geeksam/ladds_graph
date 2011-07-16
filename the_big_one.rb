$: << File.expand_path(File.join(File.dirname(__FILE__), *%w[lib]))

require 'graph'
require 'map'
require 'ladds_graph'

path = Ladds.path(42)

opts = {
  :max_backtrack_count        => 7,
  :backtrack_avoidance_factor => 4,
  :persistence_factor         => 6,
  # :randomize                  => true,
}
paths = path.go_forth_and_multiply(opts.merge({
  :debug_every_n_steps     => 50_000,
  :stop_after_n_iterations => 50_000,
  :max_path_length         => 250,
}))

puts "\n\nDone!"
puts paths.to_a.sort.map { |e| e.last.inspect }.join("\n")

puts 'Total DFS steps: %d' % path.dfs_counter.count
