require 'test_helper'

describe Graph do
  it 'should have edges' do
    g = Graph.new
    assert_equal [], g.edges

    foobar = g.edge(:foo, :bar)
    assert_equal [foobar], g.edges

    assert_kind_of Graph::Edge, foobar
    assert_equal :foo, foobar.n1
    assert_equal :bar, foobar.n2
    assert_nil foobar.points
  end

  it 'should have an adjacency hash' do
    g = Graph.new
    foo_foobar    = g.edge(:foo, :foobar)
    foo_food      = g.edge(:foo, :food)
    bar_barforama = g.edge(:bar, :barforama)
    
    assert_equal [foo_foobar, foo_food], g.edges_for(:foo)
    assert_equal [bar_barforama],        g.edges_for(:bar)

    assert_equal [foo_foobar],    g.edges_for(:foobar)
    assert_equal [foo_food],      g.edges_for(:food)
    assert_equal [bar_barforama], g.edges_for(:barforama)
  end
end

describe Graph::Edge do
  it 'is adjacent if either node of self is == to either node of other' do
    build_square
    
    assert @ab.adjacent_to?(@bc)
    refute @ab.adjacent_to?(@cd)
    assert @ab.adjacent_to?(@ad)

    assert @bc.adjacent_to?(@cd)
    refute @bc.adjacent_to?(@da)
    assert @bc.adjacent_to?(@ab)

    assert @cd.adjacent_to?(@da)
    refute @cd.adjacent_to?(@ab)
    assert @cd.adjacent_to?(@bc)

    assert @da.adjacent_to?(@ab)
    refute @da.adjacent_to?(@bc)
    assert @da.adjacent_to?(@cd)
  end
end

describe Graph::Path do
  before do
    build_square
  end
  
  it 'adds segments by traversing edges' do
    path = @square.path(:a)
    assert_equal [], path.segments
    assert_equal :a, path.current_node

    path.traverse(@ab)
    assert_equal [@ab], path.segments
    assert_equal :b, path.current_node
    
    path.traverse(@bc)
    assert_equal [@ab, @bc], path.segments
    assert_equal :c, path.current_node
  end
  
  it "complains if traversing an edge that doesn't connect to the current node" do
    path = @square.path(:a)
    path.traverse(@ab)
    assert_raises(Graph::UnreachableEdge) do
      path.traverse(@cd)
    end
  end
  
  it 'adds segments by traveling to nodes' do
    path = @square.path(:a)
    assert_equal [], path.segments
    assert_equal :a, path.current_node

    path.travel_to(:b)
    assert_equal [@ab], path.segments
    assert_equal :b, path.current_node
    
    path.travel_to(:c)
    assert_equal [@ab, @bc], path.segments
    assert_equal :c, path.current_node
  end

  it 'complains if traveling to a non-adjacent node' do
    path = @square.path(:a)
    assert_raises(Graph::UnreachableNode) do
      path.travel_to(:c)
    end
  end

  it 'makes a [shallow] copy of the segments array when cloned' do
    fred = @square.path(:a)
    fred.travel_to(:b)
    derf = fred.clone

    fred.travel_to(:c)
    assert_equal :c, fred.current_node
    assert_equal [@ab, @bc], fred.segments, "Sanity check failed; wtf?"

    derf.travel_to(:a)
    assert_equal :a, derf.current_node
    assert_equal [@ab, @ba], derf.segments, "O NOES I HAS A SHALLOW COPY"
  end
end
