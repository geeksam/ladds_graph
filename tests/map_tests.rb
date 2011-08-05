require 'test_helper'

describe Map::Path do
  before do
    build_tiny_ladds
    @path = @tiny_ladds.path(:ladds_circle)
  end

  it 'does sanity checks on the graph before going any further, dammit' do
    assert_equal 16, @tiny_ladds.edges.length
  end

  it 'makes a [shallow] copy of the sets and score when cloned' do
    @path.travel_to :hawthorne_and_12th, :hawthorne_and_16th, :ladds_circle
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
end
