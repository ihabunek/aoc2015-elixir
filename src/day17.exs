# --- Day 17: No Such Thing as Too Much ---
# https://adventofcode.com/2015/day/17

defmodule Combinatorics do
  def combinations(0, _), do: [[]]
  def combinations(_, []), do: []

  def combinations(len, [h | t]) do
    for(l <- combinations(len - 1, t), do: [h | l]) ++ combinations(len, t)
  end
end

defmodule Day17 do
  def combos(canisters) do
    for len <- 1..Enum.count(canisters) do
      Combinatorics.combinations(len, canisters)
    end
    |> Enum.concat()
  end

  def part1(canisters, target) do
    combos(canisters)
    |> Enum.filter(&(Enum.sum(&1) == target))
    |> Enum.count()
  end

  def part2(canisters, target) do
    combinations =
      combos(canisters)
      |> Enum.filter(&(Enum.sum(&1) == target))

    min_number =
      combinations
      |> Enum.map(&Enum.count/1)
      |> Enum.min()

    combinations
    |> Enum.filter(&(Enum.count(&1) == min_number))
    |> Enum.count()
  end
end

canisters = [33, 14, 18, 20, 45, 35, 16, 35, 1, 13, 18, 13, 50, 44, 48, 6, 24, 41, 30, 42]
target = 150

Day17.part1(canisters, target) |> IO.inspect(label: "Part 1")
Day17.part2(canisters, target) |> IO.inspect(label: "Part 2")
