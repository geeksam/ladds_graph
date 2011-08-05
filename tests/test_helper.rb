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

def tiny_ladds
  build_tiny_ladds if @tiny_ladds.nil?
  @tiny_ladds
end

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

  @borders       = [@b1, @b2, @b3, @b4, @b5, @b6, @b7, @b8]
  @spokes        = @tiny_ladds.streets - @borders
  @diagonals     = [@nw_ladd, @se_ladd, @ne_elliot, @sw_elliot]
  @non_diagonals = [@n_16th, @e_harrison, @s_16th, @w_harrison]

  # XY coordinates!  Put the origin at the bottom left, which should make coordinates really obvious
  @tiny_ladds.XY :ladds_circle,       [  0,  0 ]
  @tiny_ladds.XY :hawthorne_and_12th, [ -1,  1 ]
  @tiny_ladds.XY :hawthorne_and_16th, [  0,  1 ]
  @tiny_ladds.XY :hawthorne_and_20th, [  1,  1 ]
  @tiny_ladds.XY :harrison_and_12th,  [ -1,  0 ]
  @tiny_ladds.XY :harrison_and_20th,  [  1,  0 ]
  @tiny_ladds.XY :division_and_12th,  [ -1, -1 ]
  @tiny_ladds.XY :division_and_16th,  [  0, -1 ]
  @tiny_ladds.XY :division_and_20th,  [  1, -1 ]
end
