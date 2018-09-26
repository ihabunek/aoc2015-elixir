# Day 18: Science for Hungry People
# https://adventofcode.com/2015/day/18

defmodule Day18 do
  def parse_line(line) do

  end

  def parse_input_to_map(input) do
    lines = input |> String.split("\n")
    range = 0..(Enum.count(lines) - 1)
    Enum.reduce(range, MapSet.new(), fn y, acc ->
      line = Enum.at(lines, y)
      range = 0..(String.length(line) - 1)
      Enum.reduce(range, acc, fn x, acc ->
        char = String.at(line, x)
        if char == "#" do
          acc = MapSet.put(acc, {x, y})
        else
          acc
        end
      end)
    end)
  end

  def part1(input) do
    input |> parse_input_to_map
  end

  def part2(_) do
  end
end


input = File.read!("day18.example.in")

Day18.part1(input) |> IO.inspect
# Day18.part2(input) |> IO.inspect
