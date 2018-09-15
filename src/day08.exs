# Day 8: Matchsticks
# http://adventofcode.com/2015/day/8

defmodule Day08 do
    def replace(string, pattern, replacement) do
        Regex.replace(pattern, string, replacement)
    end

    def count_in_memory(line) do
        line |> String.trim("\"")
             |> replace(~r/\\("|\\|x..)/, "?")
             |> String.length
    end

    def part1(input) do
        in_memory = input |> Enum.map(&count_in_memory/1) |> Enum.sum
        on_disk = input |> Enum.map(&String.length/1) |> Enum.sum
        on_disk - in_memory
    end

    def is_encodable(char) do
        char in [?\\ , ?"]
    end

    def count_encodable(line) do
        line |> to_charlist
             |> Enum.filter(&is_encodable/1) 
             |> Enum.count
    end

    def part2(input) do
        # Each encodable character replaced by 2, plus wrapped in quotes
        input |> Enum.map(&count_encodable/1)
              |> Enum.map(&(&1 + 2))
              |> Enum.sum
    end
end

input = File.read!("day08.in") |> String.split

Day08.part1(input) |> IO.inspect
Day08.part2(input) |> IO.inspect
