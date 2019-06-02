# frozen_string_literal: true

# implementations of S-99 http://aperiodic.net/phil/scala/s-99/
class S99
  # p01
  # @param [Array]  arr
  # @return [Object] last element of arr
  def last(arr)
    arr[arr.size - 1]
  end

  # p02
  # @param [Array]  arr
  # @return [Object] the last but one element
  def penultimate(arr)
    arr[arr.size - 2]
  end

  # p03
  # @param [Integer]  idx
  # @param [Array]  arr
  # @return [Object]
  def nth(idx, arr)
    std = if idx >= 0
            arr[idx]
          else
            raise IndexError, 'index must be greater than 0'
          end

    run = lambda do |target, idx|
      if idx.negative?
        raise IndexError, 'index must be greater than 0'
      elsif idx.zero?
        target[0]
      else
        run.call(target.drop(1), idx - 1)
      end
    end

    run.call(arr, idx)
  end

  # p04
  # @param [Array]  arr
  # @return [Integer]
  def length(arr)
    run = lambda do |rest, len|
      rest[0].nil? ? len : run.call(rest.drop(1), len + 1)
    end

    run.call(arr, 0)
    # arr.size
  end

  # p05
  # @param [Array]  arr
  # @return [Array] reversed arr
  def reverse(arr)
    run = lambda do |rest, result|
      rest[0].nil? ? result : run.call(rest.drop(1), result.insert(0, rest[0]))
    end
    run.call(arr, [])
  end

  # p06
  # @param [Array]  arr
  # @return [bool]
  def palindrome?(arr)
    (arr.length / 2).times do |i|
      return false if arr[i] != arr[-(1 + i)]
    end
    true
  end

  # p07
  # @param [Array]  arr
  # @return [Array]
  def flatten(arr)
    result = []
    arr.each do |elm|
      case elm
      when Array then
        result.push(*flatten(elm))
      else
        result << elm
      end
    end
    result
    # arr.flatten()
  end

  # p08
  # @param [Array]  arr
  # @return [Array]
  def compress(arr)
    run = lambda do |rest, result, last_element|
      return result if rest.empty?

      if rest[0] == last_element
        run.call(rest.drop(1), result, last_element)
      else
        run.call(rest.drop(1), result << rest[0], rest[0])
      end
    end

    run.call(arr, [], nil)
  end

  # p09
  # @param [Array]  arr
  # @return [Array]
  def pack(arr)
    run = lambda do |rest, result, last_element|
      return result if rest.empty?

      if rest[0] == last_element
        result[-1] << rest[0]
        run.call(rest.drop(1), result, last_element)
      else
        run.call(rest.drop(1), result << [rest[0]], rest[0])
      end
    end

    run.call(arr, [], nil)
  end

  # p10
  # @param [Array]  arr
  # @return [Array]
  def encode(arr)

    run = lambda do |rest, result, last_element|
      return result if rest.empty?

      if rest[0] == last_element
        result[-1].increment
        run.call(rest.drop(1), result, last_element)
      else
        result << RunLength.new(rest[0])
        run.call(rest.drop(1), result, rest[0])
      end
    end

    run.call(arr, [], nil)
  end
end

# class for P10
# @attr_reader [Object] key
# @attr_reader [Integer] count
class RunLength
  attr_reader :key, :count

  # @param [Object]  key
  # @param [Integer]  count
  def initialize(key, count = 1)
    @key = key
    @count = count
  end

  def increment
    @count += 1
  end

  def ==(other)
    case other
    when RunLength
      other.key == @key && other.count == @count
    else
      false
    end
  end

  def to_s
    "RunLength(#{@key}: #{@count})"
  end

  def inspect
    to_s
  end
end

def main
  s = S99.new
  p s.last([1, 2, 3])
end
