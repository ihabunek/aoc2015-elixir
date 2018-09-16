# Day 12: JSAbacusFramework.io
# https://adventofcode.com/2015/day/12

defmodule Day12 do
    def part1(input) do
        Regex.scan(~r/(-?\d+)/, input)
            |> Enum.map(&List.first/1)
            |> Enum.map(&String.to_integer/1)
            |> Enum.sum
    end

    def proc_list(list) do
        list |> Enum.map(&find_numbers/1) |> Enum.sum
    end

    def proc_map(map) do
        if "red" in Map.values(map) do
            0
        else
            map |> Map.values
                |> Enum.map(&find_numbers/1)
                |> Enum.sum
        end
    end

    def find_numbers(item) do
        cond do
            is_map(item) -> proc_map(item)
            is_list(item) -> proc_list(item)
            is_integer(item) -> item
            is_bitstring(item) -> 0
        end
    end

    def json_to_elixir(input) do
        # Naive conversion from JSON to an Elixir data structure
        input |> String.replace("{", "%{")
              |> String.replace(":", "=>")
              |> Code.eval_string
              |> elem(0)
    end

    def part2(input) do
        input |> json_to_elixir |> find_numbers
    end
end

input = File.read!("day12.in")

Day12.part1(input) |> IO.inspect
Day12.part2(input) |> IO.inspect

