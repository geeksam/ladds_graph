require 'test_helper'
require 'ladds_digraph'

class Graph
  def reverse_edge(edge)
    edges.detect { |e| e.n1 == edge.n2 && e.n2 == edge.n1 }
  end
end

describe "Ladd's Graph" do
  it 'has no self edges' do
    assert Ladds.edges.all? { |e| e.n1 != e.n2 }
  end
  
  it "has all edges defined bidirectionally" do
    ups, downs = Ladds.edges.partition { |e| e.n1 <= e.n2 }
    [ups, downs].each do |edgeset|
      edgeset.each do |a|
        b = Ladds.reverse_edge(a)
        refute b.nil?, "No reverse edge found for #{a}"
      end
    end
  end
end
