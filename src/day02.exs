# Day 2: I Was Told There Would Be No Math
# http://adventofcode.com/2015/day/2

defmodule Day02 do
    defp parse_line(line) do
        line |> String.split("x") |> Enum.map(&String.to_integer/1)
    end

    defp parse_input(input) do
        input |> String.split |> Enum.map(&parse_line/1)
    end

    defp paper_size([l, w, h]) do
        (2 * l * w) + (2 * w * h) + (2 * h * l) + Enum.min([l*w, w*h, h*l])
    end

    defp ribbon_length([l, w, h]) do
        Enum.min([l + w, w + h, h + l]) * 2 + l * w * h
    end

    def part1(input) do
        parse_input(input) |> Enum.map(&paper_size/1) |> Enum.sum
    end

    def part2(input) do
        parse_input(input) |> Enum.map(&ribbon_length/1) |> Enum.sum
    end
end

input = File.read!("day02.in")
Day02.part1(input) |> IO.inspect
Day02.part2(input) |> IO.inspect
