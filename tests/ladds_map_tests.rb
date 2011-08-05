require 'test_helper'
require 'ladds_graph'

describe "the trivial path from 7 to 30" do

  it 'should have a distance of 0.165' do
    path = Ladds.path(7)
    path.travel_to(30)
    assert_equal 1, path.length
    assert_in_delta 0.165, path.distance, 0.001
  end

end

