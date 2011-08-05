require 'test_helper'
require 'ladds_graph'

DavesKillerPathNodes = [
  51, 61, 74, 79, 84, 77, 71, 78, 82, 85, 84, 88, 89, 93, 92, 95, 96, 97, 90, 89, 
  85, 86, 80, 98, 99, 91, 72, 69, 66, 63, 54, 53, 33, 13, 24, 59, 83, 91, 99, 75, 
  80, 67, 64, 62, 75, 72, 53, 52, 42, 30, 23, 19, 26, 29, 36, 41, 40, 28, 12, 11, 
  20, 44, 81, 73, 45, 44, 20, 11, 1, 2, 3, 8, 9, 10, 5, 6, 23, 36, 21, 17, 14, 
  15, 16, 19, 18, 22, 25, 17, 18, 15, 9, 4, 5, 6, 7, 13, 24, 59, 58, 76, 69, 57, 
  35, 31, 58, 57, 56, 55, 43, 38, 35, 33, 30, 7, 6, 5, 4, 3, 2, 21, 28, 32, 34, 
  46, 45, 27, 20, 11, 32, 50, 70, 87, 94, 74, 70, 68, 46, 47, 65, 60, 48, 47, 37, 
  39, 49, 50, 51, 40
]

def daves_killer_path
  @daves_killer_path ||= begin
    nodes = DavesKillerPathNodes.dup
    Ladds.path(nodes.shift).tap { |path| path.travel_to(nodes) }
  end
end

describe "Dave's killer path" do
  it 'should be 116 points of awesomeness' do
    assert_equal 116, daves_killer_path.score
  end
  
  it 'should never backtrack, because backtracking is totally not awesome' do
    assert daves_killer_path.backtracked_streets.empty?
  end

  # See how I cleverly disguise a query as a test?
  it 'should have a non-zero length in miles' do
    assert_in_delta 9.1, daves_killer_path.distance, 0.1
  end
end
