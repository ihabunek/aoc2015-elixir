# Day 15: Science for Hungry People
# https://adventofcode.com/2015/day/15

defmodule Day15 do
  def combinations() do
    range = 0..100
    for i <- range, j <- range, k <- range, l <- range  do
      [i, j, k, l]
    end |> Stream.filter(&(Enum.sum(&1) == 100))
  end

  def part1(input) do
    combinations() |> Stream.count
  end

  def part2(input) do
    input
  end
end

example_input = %{
  "Butterscotch" => [capacity: -1, durability: -2, flavor: 6, texture: 3, calories: 8],
  "Cinnamon" => [capacity: 2, durability: 3, flavor: -2, texture: -1, calories: 3],
}

input = %{
  "Sprinkles" => [capacity: 2, durability: 0, flavor: -2, texture: 0, calories: 3],
  "Butterscotch" => [capacity: 0, durability: 5, flavor: -3, texture: 0, calories: 3],
  "Chocolate" => [capacity: 0, durability: 0, flavor: 5, texture: -1, calories: 8],
  "Candy" => [capacity: 0, durability: -1, flavor: 0, texture: 5, calories: 8],
}

Day15.part1(example_input) |> IO.inspect
# Day15.part2(input) |> IO.inspect
