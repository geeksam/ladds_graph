require 'test_helper'
require 'search/brute_force_dfs'

describe 'depth-first search' do
  it 'returns a list of paths that are circuits' do
    skip "too complex to test, I think"
    paths = @path.go_forth_and_multiply({
      :max_path_length => 10,
      :backtrack_avoidance_factor => 4,
      :persistence_factor => 3,
    })
    # assert_kind_of Array, paths
    # refute paths.empty?
    puts '', paths.to_a.sort.map { | e | e.last.inspect }.join("\n")

    puts 'Total paths found: %d' % paths.length
    puts 'DFS steps: %d' % @path.dfs_counter.count
    # puts "Scores: %s" % paths.map(&:score).inspect
  end
  # it 'does not follow edge from step N on step N+1'
  # it 'does not follow edge from step N on step N+K'  #?
  # it 'stops recursing when score has not increased in the past N moves (n=?)'
end
