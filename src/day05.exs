# Day 5: Doesn't He Have Intern-Elves For This?
# http://adventofcode.com/2015/day/5

defmodule Day05 do
    defp is_vowel?(char) do
        char in [?a, ?e, ?i, ?o, ?u]
    end

    defp count_vowels(string) do
        string |> to_charlist |> Enum.filter(&is_vowel?/1) |> Enum.count
    end

    defp has_three_vowels(string) do
        count_vowels(string) >= 3
    end

    defp letter_appears_twice(string) do
        Regex.match?(~r/([a-z])\1/, string)
    end

    defp blacklist(string) do
        not Regex.match?(~r/(ab|cd|pq|xy)/, string)
    end

    defp letter_pair_appears_twice(string) do
        Regex.match?(~r/([a-z]{2}).*\1/, string)
    end

    defp letter_repeats_with_divider(string) do
        Regex.match?(~r/([a-z]).\1/, string)
    end

    def part1(input) do
        input
            |> Enum.filter(&has_three_vowels/1)
            |> Enum.filter(&letter_appears_twice/1)
            |> Enum.filter(&blacklist/1)
            |> Enum.count
    end

    def part2(input) do
        input
            |> Enum.filter(&letter_pair_appears_twice/1)
            |> Enum.filter(&letter_repeats_with_divider/1)
            |> Enum.count
    end
end

input = File.read!("day05.in") |> String.split

Day05.part1(input) |> IO.inspect
Day05.part2(input) |> IO.inspect
