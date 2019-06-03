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

  # p11
  # @param [Array]  arr
  # @return [Array]
  def encode_modified(arr)
    run = lambda do |rest, result, last_element|
      return result if rest.empty?

      if rest[0] == last_element
        case result[-1]
        when RunLength
          result[-1].increment
        else
          result[-1] = RunLength.new(rest[0], 2)
        end

        run.call(rest.drop(1), result, last_element)
      else
        result << rest[0]
        run.call(rest.drop(1), result, rest[0])
      end
    end

    run.call(arr, [], nil)
  end

  # p12
  # @param [Array<RunLength>]  rls
  # @return [Object]
  def decode(rls)
    rls.each_with_object([]) do |rl, acc|
      rl.count.times do
        acc << rl.key
      end
    end
  end

  # p13 skipped

  # p14
  # @param [Array]  arr
  # @return [Array]
  def duplicate(arr)
    arr.each_with_object([]) do |elm, acc|
      2.times { acc << elm }
    end
  end

  # p15
  # @param [Integer]  n
  # @param [Array]  arr
  # @return [Array]
  def duplicate_n(n, arr)
    arr.each_with_object([]) do |elm, acc|
      n.times { acc << elm }
    end
  end

  # p16
  # @param [Integer]  n
  # @param [Array]  arr
  # @return [Array]
  def drop(n, arr)
    return arr if n <= 0 || n > arr.length - 1

    arr.delete_at(n - 1)
    arr
  end

  # p17
  # @param [Integer]  n
  # @param [Array]  arr
  # @return [Array<Array, Array>]
  def split(n, arr)
    left = []
    right = []

    arr.each_with_index do |elm, i|
      if i < n
        left << elm
      else
        right << elm
      end
    end
    [left, right]
  end

  # p18
  # @param [Integer]  i  begin index
  # @param [Integer]  j  end index
  # @param [Array]  arr target array
  # @return [Array] sliced array
  def slice(i, j, arr)
    return [] if i < 0 || j < 0 || j < i

    result = []
    arr.each_with_index do |elm, idx|
      if i <= idx && idx <= j
        result << elm
      elsif j < idx
        return result
      end
    end
    result
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
