$: << File.expand_path(File.join(File.dirname(__FILE__), *%w[.. lib]))

require 'rubygems'
require 'minitest/spec'
require 'minitest/autorun'

require 'graph'
require 'map'


def build_square
  @square = Graph.new
  @ab = @ba = @square.edge(:a, :b, 1)
  @bc = @cb = @square.edge(:b, :c, 1)
  @cd = @dc = @square.edge(:c, :d, 1)
  @da = @ad = @square.edge(:d, :a, 1)
end

