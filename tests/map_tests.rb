require 'test_helper'

def build_tiny_ladds
  @tiny_ladds = Map.new
  @tiny_ladds.starting_and_ending_nodes = [:ladds_circle]

  # This is a simplified map consisting of eight radial streets from Ladd's Circle and eight borders.
  # East-west streets are (from top) Hawthorne, Harrison, and Division.
  # North-south streets are (from left) 12th, 16th, and 20th.
  # Diagonal streets are Ladd (NW-SE) and Elliot (SW-NE).
  #
  #   +1+2+
  #   8\|/3
  #   +-O-+
  #   7/|\4
  #   +6+5+

  @b1 = @tiny_ladds.border(:hawthorne_and_12th, :hawthorne_and_16th)
  @b2 = @tiny_ladds.border(:hawthorne_and_16th, :hawthorne_and_20th)
  @b3 = @tiny_ladds.border(:hawthorne_and_20th, :harrison_and_20th)
  @b4 = @tiny_ladds.border(:harrison_and_20th,  :division_and_20th)
  @b5 = @tiny_ladds.border(:division_and_20th,  :division_and_16th)
  @b6 = @tiny_ladds.border(:division_and_16th,  :division_and_12th)
  @b7 = @tiny_ladds.border(:division_and_12th,  :harrison_and_12th)
  @b8 = @tiny_ladds.border(:harrison_and_12th,  :hawthorne_and_12th)

  @nw_ladd    = @tiny_ladds.street(:ladds_circle, :hawthorne_and_12th)
  @n_16th     = @tiny_ladds.street(:ladds_circle, :hawthorne_and_16th)
  @ne_elliot  = @tiny_ladds.street(:ladds_circle, :hawthorne_and_20th)
  @e_harrison = @tiny_ladds.street(:ladds_circle, :harrison_and_20th)
  @se_ladd    = @tiny_ladds.street(:ladds_circle, :division_and_20th)
  @s_16th     = @tiny_ladds.street(:ladds_circle, :division_and_16th)
  @sw_elliot  = @tiny_ladds.street(:ladds_circle, :division_and_12th)
  @w_harrison = @tiny_ladds.street(:ladds_circle, :harrison_and_12th)
end

describe Map::Path do
  before do
    build_tiny_ladds
    @path = @tiny_ladds.path(:ladds_circle)
  end

  it 'does sanity checks on the graph before going any further, dammit' do
    assert_equal 16, @tiny_ladds.edges.length
  end

  it 'makes a [shallow] copy of the sets and score when cloned' do
    @path.travel_to :hawthorne_and_12th
    @path.travel_to :hawthorne_and_16th
    @path.travel_to :ladds_circle
    assert_equal 2, @path.unique_streets.length
    assert_equal 0, @path.backtracked_streets.length

    junior = @path.clone
    junior.travel_to :hawthorne_and_12th
    assert_equal 1, junior.unique_streets.length
    assert_equal 1, junior.backtracked_streets.length
    
    assert_equal 2, @path.unique_streets.length
    assert_equal 0, @path.backtracked_streets.length
  end
  
  describe '#score' do
    def assert_score(expected_score)
      assert_equal expected_score, @path.score
    end

    it 'should be 0 for an empty path' do
      assert_equal 0, @path.segments.length
      assert_score 0
    end
    
    it 'should be 1 for a path with one street' do
      @path.traverse @nw_ladd
      assert_score 1
    end

    it 'should be 1 for a path with one street and one border' do
      @path.traverse @nw_ladd
      @path.traverse @b1
      assert_score 1
    end
    
    it 'should be 2 for a path with two streets and one border' do
      @path.traverse @nw_ladd
      @path.traverse @b1
      @path.traverse @n_16th
      assert_score 2
    end
    
    it 'should be -1 for a path with one street, traversed twice' do
      2.times { @path.traverse @nw_ladd }
      assert_score -1
    end
    
    it 'should be -1 for a path with one street, traversed six times' do
      6.times { @path.traverse @nw_ladd }
      assert_score -1
    end
    
    it 'should be 2 for a path with two streets traversed once each and one border traversed five times' do
      @path.traverse @nw_ladd
      5.times { @path.traverse @b1 }
      @path.traverse @n_16th
      assert_score 2
    end
    
    it 'should be 0 for a path with one unique street, one border, and one backtracked street' do
      @path.traverse @nw_ladd
      @path.traverse @b1
      2.times { @path.traverse @n_16th }
      assert_score 0
    end
  end

  describe '#start and #finish' do

    it 'works' do
      assert_equal :ladds_circle, @path.start
      assert_equal :ladds_circle, @path.finish
      
      @path.traverse @nw_ladd
      assert_equal :ladds_circle, @path.start
      assert_equal :hawthorne_and_12th, @path.finish

      @path.traverse @b8
      assert_equal :ladds_circle, @path.start
      assert_equal :harrison_and_12th, @path.finish
    end

  end

  describe '#is_circuit?' do
    it "is true when a path starts and ends at :ladds_circle" do
      refute @path.is_circuit?
      @path.traverse @nw_ladd
      refute @path.is_circuit?
      @path.traverse @nw_ladd
      assert @path.is_circuit?
    end
  end

  describe 'depth-first search' do
    it 'returns a list of paths that are circuits' do
      # skip "too complex to test, I think"
      paths = @path.go_forth_and_multiply({
        :max_path_length => 10,
        :backtrack_avoidance_factor => 4,
        :persistence_factor => 3,
      })
      # assert_kind_of Array, paths
      # refute paths.empty?
      puts '', paths.to_a.sort.map { | e | e.last.inspect }.join("\n") |

      puts 'Total paths found: %d' % paths.length
      puts 'DFS steps: %d' % @path.dfs_counter.count
      # puts "Scores: %s" % paths.map(&:score).inspect
    end
    # it 'does not follow edge from step N on step N+1'
    # it 'does not follow edge from step N on step N+K'  #?
    # it 'stops recursing when score has not increased in the past N moves (n=?)'
  end

end
