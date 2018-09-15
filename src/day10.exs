# Day 10: Elves Look, Elves Say
# https://adventofcode.com/2015/day/10


defmodule Day10 do
    # --- regex implementation (slower) ---------------------------------------

    def process_regex_match(match) do
        str = match |> List.first
        (str |> String.length |> Integer.to_string) <> (str |> String.at(0))
    end

    def look_and_say_regex(input) do
        # Split string into groups of consecutive identical digits
        Regex.scan(~r/1+|2+|3+|4+|5+|6+|7+|8+|9+|0+/, input) 
            |> Enum.map(&process_regex_match/1)
            |> Enum.join
    end

    # --- chunk_by implementation (faster) ------------------------------------

    def process_chunk(chunk) do
        (chunk |> length |> Integer.to_string) <> List.first(chunk)
    end

    def look_and_say(input) do
        input |> String.split("", trim: true) 
              |> Enum.chunk_by(fn x -> x end) 
              |> Enum.map(&process_chunk/1) 
              |> Enum.join
    end

    # --- repeat --------------------------------------------------------------

    # this must exist in Elixir core, right?
    def repeat(_, input, 0) do
        input
    end

    def repeat(fun, input, count) do
        repeat(fun, fun.(input), count - 1)
    end
    
    # --- run -----------------------------------------------------------------

    def part1(input) do
        repeat(&look_and_say_regex/1, input, 40) |> String.length
    end

    def part2(input) do
        repeat(&look_and_say/1, input, 50) |> String.length
    end
end

input = "1113222113"

Day10.part1(input) |> IO.inspect
Day10.part2(input) |> IO.inspect
