require 'test_helper'

describe Map do
  before do
    build_tiny_ladds
  end

  it 'does sanity checks on the graph before going any further, dammit' do
    assert_equal 16, tiny_ladds.edges.length
    assert_equal [0, 0], tiny_ladds.XY(:ladds_circle)
  end

  describe 'distance calculations' do
    it 'works for borders' do
      @borders.each do |e|
        assert_equal 1, tiny_ladds.distance_of(e)
      end
    end

    it 'works for spokes' do
      @diagonals.each do |e|
        assert_equal Math.hypot(1, 1), tiny_ladds.distance_of(e), e.inspect
      end
      @non_diagonals.each do |e|
        assert_equal 1, tiny_ladds.distance_of(e), e.inspect
      end
    end

    it "uses the map's scaling factor" do
      assert_equal 1, tiny_ladds.distance_of(@b1)
      tiny_ladds.scaling_factor = 42
      assert_equal 42, tiny_ladds.distance_of(@b1)
    end

    def assert_angle(expected, actual, msg = '')
      assert_in_delta expected, actual, 0.5, msg
    end

    it 'can calculate an angle' do
      assert_angle   0, tiny_ladds.angle_between(:ladds_circle, :harrison_and_20th),  'E'
      assert_angle  45, tiny_ladds.angle_between(:ladds_circle, :hawthorne_and_20th), 'NE'
      assert_angle  90, tiny_ladds.angle_between(:ladds_circle, :hawthorne_and_16th), 'N'
      assert_angle 135, tiny_ladds.angle_between(:ladds_circle, :hawthorne_and_12th), 'NW'
      assert_angle 180, tiny_ladds.angle_between(:ladds_circle, :harrison_and_12th),  'W'
      assert_angle 225, tiny_ladds.angle_between(:ladds_circle, :division_and_12th),  'SW'
      assert_angle 270, tiny_ladds.angle_between(:ladds_circle, :division_and_16th),  'S'
      assert_angle 315, tiny_ladds.angle_between(:ladds_circle, :division_and_20th),  'SE'

      begin
        tiny_ladds.coordinates[:north_northeast] = [0.1, 1]
	      assert_angle  84, tiny_ladds.angle_between(:ladds_circle, :north_northeast),  'NNE'
      ensure
        tiny_ladds.coordinates.delete(:north_northeast)
      end
    end

    it 'can calculate a direction' do
      assert_equal :E,  tiny_ladds.direction(:ladds_circle, :harrison_and_20th)
      assert_equal :NE, tiny_ladds.direction(:ladds_circle, :hawthorne_and_20th)
      assert_equal :N,  tiny_ladds.direction(:ladds_circle, :hawthorne_and_16th)
      assert_equal :NW, tiny_ladds.direction(:ladds_circle, :hawthorne_and_12th)
      assert_equal :W,  tiny_ladds.direction(:ladds_circle, :harrison_and_12th)
      assert_equal :SW, tiny_ladds.direction(:ladds_circle, :division_and_12th)
      assert_equal :S,  tiny_ladds.direction(:ladds_circle, :division_and_16th)
      assert_equal :SE, tiny_ladds.direction(:ladds_circle, :division_and_20th)
    end

    it 'can calculate a direction even with a funky angle' do
      begin
        tiny_ladds.coordinates[:north_northeast] = [0.1, 1]
        assert_equal :N, tiny_ladds.direction(:ladds_circle, :north_northeast)
      ensure
        tiny_ladds.coordinates.delete(:north_northeast)
      end
    end
  end
end

describe Map::Path do
  before do
    build_tiny_ladds
    @path = tiny_ladds.path(:ladds_circle)
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
