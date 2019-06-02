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
end