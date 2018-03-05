# Day 3: Perfectly Spherical Houses in a Vacuum
# http://adventofcode.com/2015/day/3

defmodule Day03 do
    def parse_direction(char) do
        case char do
            "<" -> {-1,  0}
            ">" -> { 1,  0}
            "^" -> { 0,  1}
            "v" -> { 0, -1}
        end
    end

    def parse_input(input) do
        input |> String.graphemes |> Enum.map(&parse_direction/1)
    end

    defp move({x, y}, {dx, dy}) do
        {x + dx, y + dy}
    end

    defp follow_path(moves) do
        follow_path(moves, {0, 0}, [])
    end

    defp follow_path([], position, path) do
        path ++ [position]
    end

    defp follow_path(moves, position, path) do
        follow_path(
            tl(moves),
            move(position, hd(moves)),
            path ++ [position]
        )
    end

    def part1(input) do
        input |> parse_input |> follow_path |> Enum.uniq |> Enum.count
    end

    def part2(input) do
        moves = parse_input(input)

        path1 = moves |> Enum.take_every(2) |> follow_path
        path2 = moves |> Enum.drop_every(2) |> follow_path

        path1 ++ path2 |> Enum.uniq |> Enum.count
    end
end

input = File.read!("day03.in")
Day03.part1(input) |> IO.inspect
Day03.part2(input) |> IO.inspect
