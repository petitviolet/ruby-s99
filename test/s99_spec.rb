# frozen_string_literal: true

require 'minitest/autorun'

Dir[File.expand_path('..', __dir__) << '/*.rb'].each do |file|
  puts "require: #{file}"
  require file
end

puts '=========='

class S99Test < Minitest::Test
  def setup
    @s99 = S99.new
  end

  def test_last
    assert_nil @s99.last([])
    assert_equal 8, @s99.last([1, 1, 2, 3, 5, 8])
  end

  def test_penultimate
    assert_nil @s99.penultimate([])
    assert_equal 5, @s99.penultimate([1, 1, 2, 3, 5, 8])
  end

  def test_nth
    assert_raises IndexError do
      @s99.nth(-1, [1, 1, 2, 3, 5, 8])
    end
    assert_equal 1, @s99.nth(0, [1, 1, 2, 3, 5, 8])
    assert_equal 2, @s99.nth(2, [1, 1, 2, 3, 5, 8])
  end

  def test_len
    assert_equal 0, @s99.length([])
    assert_equal 6, @s99.length([1, 1, 2, 3, 5, 8])
  end

  def test_reverse
    assert_empty @s99.reverse([])
    assert_equal [3, 2, 1], @s99.reverse([1, 2, 3])
  end

  def test_is_palindrome
    assert_equal true, @s99.palindrome?([])
    assert_equal true, @s99.palindrome?([1, 2, 3, 2, 1])
    assert_equal true, @s99.palindrome?([1, 2, 2, 1])
    assert_equal false, @s99.palindrome?([1, 2, 3, 1])
    assert_equal false, @s99.palindrome?([1, 2, 3, 1, 2])
  end

  def test_flatten
    assert_empty @s99.flatten([])
    assert_equal [1, 1, 2, 3, 5, 8], @s99.flatten([[1, 1], 2, [3, [5, 8]]])
  end

  def test_compress
    assert_empty @s99.compress([])
    assert_equal %i[a b c a d e], @s99.compress(%i[a b c a d e])
    assert_equal %i[a b c a d e], @s99.compress(%i[a a a b b c a a d d d d e])
  end

  def test_pack
    assert_empty @s99.pack([])
    assert_equal [%i[a a a], %i[b b], [:c], %i[a a], %i[d d d d], [:e]],
                 @s99.pack(%i[a a a b b c a a d d d d e])
  end

  def test_encode
    assert_empty @s99.encode([])
    assert_equal [RunLength.new(:a, 3), RunLength.new(:b, 2), RunLength.new(:c, 1),
                  RunLength.new(:a, 2), RunLength.new(:d, 4), RunLength.new(:e, 1)],
                 @s99.encode(%i[a a a b b c a a d d d d e])
  end

  def test_encode_modified
    assert_empty @s99.encode_modified([])
    assert_equal [RunLength.new(:a, 3), RunLength.new(:b, 2), :c,
                  RunLength.new(:a, 2), RunLength.new(:d, 4), :e],
                 @s99.encode_modified(%i[a a a b b c a a d d d d e])
  end

  def test_decode
    assert_empty @s99.decode([])
    assert_equal %i[a a a b b c a a d d d d e],
                 @s99.decode([RunLength.new(:a, 3), RunLength.new(:b, 2), RunLength.new(:c, 1),
                              RunLength.new(:a, 2), RunLength.new(:d, 4), RunLength.new(:e, 1)])

    symbols = %i[a a a b b c a a d d d d e]
    assert_equal symbols, @s99.decode(@s99.encode(symbols))
  end

  def test_duplicate
    assert_empty @s99.duplicate([])
    assert_equal %i[a a b b c c d d], @s99.duplicate(%i[a b c d])
  end

  def test_duplicate_n
    assert_empty @s99.duplicate_n(3, [])
    assert_equal %i[a a b b c c d d], @s99.duplicate_n(2, %i[a b c d])
    assert_equal %i[a a a b b b c c c d d d], @s99.duplicate_n(3, %i[a b c d])
  end

  def test_drop
    assert_empty @s99.drop(1, [])
    assert_equal %i[a b c], @s99.drop(-1, %i[a b c])
    assert_equal %i[a b c], @s99.drop(4, %i[a b c])
    assert_equal %i[b c], @s99.drop(1, %i[a b c])
    assert_equal %i[a c], @s99.drop(2, %i[a b c])
  end

  def test_split
    assert_equal [[], []], @s99.split(1, [])
    assert_equal [[], [1, 2, 3, 4, 5, 6]], @s99.split(-1, [1, 2, 3, 4, 5, 6])
    assert_equal [[1, 2, 3], [4, 5, 6]], @s99.split(3, [1, 2, 3, 4, 5, 6])
  end
end
