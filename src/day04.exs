# Day 4: The Ideal Stocking Stuffer
# http://adventofcode.com/2015/day/4

defmodule Day04 do
    defp find_hash(input, starts_with, no \\ 0) do
        hash = :crypto.hash(:md5, "#{input}#{no}") |> Base.encode16

        if String.starts_with?(hash, starts_with) do
            no
        else
            find_hash(input, starts_with, no + 1)
        end
    end

    def part1(input) do
        find_hash(input, "00000")
    end

    def part2(input) do
        find_hash(input, "000000")
    end
end

input = "ckczppom"

Day04.part1(input) |> IO.inspect
Day04.part2(input) |> IO.inspect
