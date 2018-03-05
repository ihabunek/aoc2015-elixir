# Day 1: Not Quite Lisp
# http://adventofcode.com/2015/day/1

defmodule Day01 do
    defp up_down(char) do
        case char do
          "(" -> 1
          ")" -> -1
        end
    end

    defp find_basement(input, acc, pos) when acc == -1 do
        pos
    end

    defp find_basement(input, acc, pos) do
        find_basement(tl(input), hd(input) + acc, pos + 1)
    end

    defp find_basement(input) do
        find_basement(input, 0, 0)
    end

    def part1(input) do
        String.graphemes(input) |> Enum.map(&up_down/1) |> Enum.sum
    end

    def part2(input) do
        moves = input |> String.graphemes |> Enum.map(&up_down/1) |> find_basement
    end
end

input = File.read!("day01.in")

Day01.part1(input) |> IO.inspect
Day01.part2(input) |> IO.inspect
