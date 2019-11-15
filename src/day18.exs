# Day 18: Science for Hungry People
# https://adventofcode.com/2015/day/18

defmodule Day18 do
  @doc """
  Parse input grid into a map holding coordinates only of lights which are on.
  """
  def parse_input(input) do
    lines = input |> String.split("\n")

    for {line, y} <- Enum.with_index(lines),
        {char, x} <- Enum.with_index(to_charlist(line)),
        char == ?# do
      {x, y}
    end
    |> MapSet.new()
  end

  @doc """
  For given coordinates, returns up to 8 neighbouring coordinates. Skips those
  which are outside of the grid of size `size`.
  """
  def neighbours({x, y}, size) when x >= 0 and y >= 0 and x < size and y < size do
    for x1 <- (x - 1)..(x + 1),
        y1 <- (y - 1)..(y + 1),
        not (x == x1 and y == y1),
        x1 >= 0 and x1 < size,
        y1 >= 0 and y1 < size do
      {x1, y1}
    end
  end

  def keep_lit?(lights, pos, size) do
    lit_neighbour_count =
      neighbours(pos, size)
      |> Enum.filter(&MapSet.member?(lights, &1))
      |> Enum.count()

    # A light which is on stays on when 2 or 3 neighbors are on, and turns off otherwise.
    # A light which is off turns on if exactly 3 neighbors are on, and stays off otherwise.
    if MapSet.member?(lights, pos) do
      lit_neighbour_count in [2, 3]
    else
      lit_neighbour_count == 3
    end
  end

  def next_lights(lights, size) do
    for x <- 0..(size - 1),
        y <- 0..(size - 1),
        keep_lit?(lights, {x, y}, size) do
      {x, y}
    end
    |> MapSet.new()
  end

  def add_stuck_lights(lights, size) do
    # Four corner lights are always on
    max = size - 1

    lights
    |> MapSet.put({0, 0})
    |> MapSet.put({0, max})
    |> MapSet.put({max, 0})
    |> MapSet.put({max, max})
  end

  def part1(input, size) do
    lights = input |> parse_input

    Enum.reduce(1..100, lights, fn _, acc ->
      next_lights(acc, size)
    end)
    |> Enum.count()
  end

  def part2(input, size) do
    lights = input |> parse_input |> add_stuck_lights(size)

    Enum.reduce(1..100, lights, fn _, acc ->
      next_lights(acc, size)
      |> add_stuck_lights(size)
    end)
    |> Enum.count()
  end
end

input = File.read!("day18.in")
size = 100

Day18.part1(input, size) |> IO.inspect(label: "Part 1")
Day18.part2(input, size) |> IO.inspect(label: "Part 2")
