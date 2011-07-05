require 'test_helper'

describe Object do

  it 'taps' do
    foo = Object.new
    baz = foo.tap { |bar| assert_equal foo, bar; 42 }
    assert_equal foo, baz
  end

end

describe Enumerable do
  it 'sums' do
    assert_equal 2, [1, 1].sum
  end

  it 'sums with Symbol#to_proc' do
    assert_equal 2, %w[1 1].sum(&:to_i)
  end
end

describe Array do

  it 'has #last_n' do
    a = (1..3).to_a
    assert_equal [],        a.last_n(0)
    assert_equal [3],       a.last_n(1)
    assert_equal [2, 3],    a.last_n(2)
    assert_equal [1, 2, 3], a.last_n(3)
    assert_equal [1, 2, 3], a.last_n(4)
  end

end