# Day 11: Elves Look, Elves Say
# https://adventofcode.com/2015/day/11

defmodule Day11 do
    def increment(password, pos) do
        # If last char is not z, increment it, else change it to a and recurse to prev pos
        # This would fail for a string comprising of all z chars
        if Enum.at(password, pos) == ?z do
            password = List.update_at(password, pos, fn _ -> ?a end)
            increment(password, pos - 1)
        else
            List.update_at(password, pos, &(&1 + 1))
        end
    end

    def consecutive_at?(password, x) do
        Enum.at(password, x) - Enum.at(password, x - 1) == 1
    end

    def has_three_consecutive_increasing_letters?(password) do
        Enum.reduce(1..length(password) - 1, 0, fn x, acc ->
            cond do
                acc >= 2 -> 2  # already found it
                consecutive_at?(password, x) -> acc + 1
                true -> 0
            end
        end) == 2
    end

    def has_two_pairs_of_letters(password) do
        count = password |> Enum.chunk_by(fn x -> x end)
                         |> Enum.filter(&(length(&1) > 1))
                         |> Enum.map(&hd/1)
                         |> Enum.uniq
                         |> Enum.count

        count > 1
    end

    def contains_iol?(password) do
        cond do
            Enum.empty?(password) -> false
            Enum.at(password, 0) in [?i, ?o, ?l] -> true
            true -> contains_iol?(tl(password))
         end
    end

    def valid?(password) do
        has_three_consecutive_increasing_letters?(password)
            and not contains_iol?(password)
            and has_two_pairs_of_letters(password)
    end

    def increment(password) do
        increment(password, length(password) - 1)
    end

    def find_next_password(password) do
        next = increment(password)
        if valid?(next) do
            next
        else
            find_next_password(next)
        end
    end

    def part1() do
        find_next_password('cqjxjnds')
    end

    def part2() do
        find_next_password(part1())
    end
end

Day11.part1() |> IO.inspect
Day11.part2() |> IO.inspect
