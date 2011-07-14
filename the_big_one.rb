$: << File.expand_path(File.join(File.dirname(__FILE__), *%w[lib]))

require 'graph'
require 'map'
require 'ladds_graph'

path = Ladds.path(42)

# path.travel_to 30, 23, 19, 26, 29, 25, 22, 26, 29, 36, 41
# puts "w00t!" if path.is_circuit?
# puts path.inspect
# puts path.unique_streets.inspect
# puts path.backtracked_streets.inspect
# puts 'length: %d' % path.length
# puts 'Score: %d' % path.score

opts = {
  :max_backtrack_count        => 11,
  :backtrack_avoidance_factor => 5,
  :persistence_factor         => 3,
}
paths = path.go_forth_and_multiply(opts.merge({
  :debug_every_n_steps     => 50_000,
  # :stop_after_n_iterations => 50_000,
  :max_path_length         => 200,
}))

puts "\n\nDone!"
puts paths.to_a.sort.map { |e| e.last.inspect }.join("\n")

puts 'Total DFS steps: %d' % path.dfs_counter.count
