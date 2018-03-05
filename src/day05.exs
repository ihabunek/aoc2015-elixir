# Day 5: Doesn't He Have Intern-Elves For This?
# http://adventofcode.com/2015/day/5

defmodule Day05 do
    defp is_vowel?(char) do
        char in [?a, ?e, ?i, ?o, ?u]
    end

    defp has_three_vowels(string) do
        string |> to_charlist |> Enum.filter(&is_vowel?/1) |> Enum.count >= 3
    end

    defp letter_appears_twice(string) do

    end

    def part1(input) do
        input |> Enum.filter(&has_three_vowels/1)
    end

    def part2(input) do
    end
end

input = File.read!("day05.in") |> String.split

input = [
    "aaa",
    "abc",
    "aabde",
]

Day05.part1(input) |> IO.inspect
Day05.part2(input) |> IO.inspect
