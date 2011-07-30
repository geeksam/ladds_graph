require 'core_ext'
require 'graph/path'
require 'graph/edge'

class Graph
  def adjacency_hash
    @adjacency_hash ||= Hash.new { |hash, key| hash[key] = [] }
  end

  def edges_for(node)
    adjacency_hash[node]
  end

  def edges
    @edges ||= []
  end
  
  def edge(*attrs)
    Edge.new(*attrs).tap do |e|
      adjacency_hash[e.n1] << e
      adjacency_hash[e.n2] << e
      edges << e
    end
  end
end
