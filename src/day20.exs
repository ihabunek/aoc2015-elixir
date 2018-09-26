# Day 20: Infinite Elves and Infinite Houses
# https://adventofcode.com/2015/day/20

defmodule Day20 do
  def divisors(no) do
    1..trunc(:math.sqrt(no))
      |> Stream.filter(&(rem(no, &1) == 0))
      |> Stream.flat_map(&([&1, div(no, &1)]))
      |> Stream.uniq
  end

  def present_count_1(no) do
    Enum.sum(divisors(no)) * 10
  end

  def present_count_2(no, stop_after) do
    # Since elves stop after <stop_after> houses, remove those divisors
    sum = divisors(no)
      |> Stream.filter(&(&1 > div(no - 1, stop_after)))
      |> Enum.sum

    sum * 11
  end

  def common(input, count_fn) do
    Stream.iterate(1, &(&1 + 1))
      |> Stream.map(count_fn)
      |> Stream.filter(&(elem(&1, 1) > input))
      |> Stream.take(1)
      |> Enum.to_list
      |> List.first
      |> elem(0)
  end

  def part1(input) do
    common(input, &({&1, present_count_1(&1)}))
  end

  def part2(input, stop_after) do
    common(input, &({&1, present_count_2(&1, stop_after)}))
  end
end

input = 34000000
stop_after = 50

Day20.part1(input)             |> IO.inspect  # 43s
Day20.part2(input, stop_after) |> IO.inspect  # 47s
