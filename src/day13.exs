# Day 13: Knights of the Dinner Table
# https://adventofcode.com/2015/day/13

defmodule Day13 do
    def parse_line(line) do
        pattern = ~r/(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)./
        [_, person1, gain_lose, delta, person2] = Regex.run(pattern, line)
        sign = if gain_lose == "gain", do: 1, else: -1
        delta = String.to_integer(delta) * sign
        {person1, person2, delta}
    end

    def reduce_to_map(input) do
        Enum.reduce(input, %{}, fn {person1, person2, delta}, acc ->
            if not Map.has_key?(acc, person1) do
                Map.put(acc, person1, %{person2 => delta})
            else
                put_in(acc[person1][person2], delta)
            end
        end)
    end

    def parse_input(input) do
        input |> String.split("\n")
              |> Enum.map(&parse_line/1)
              |> reduce_to_map
    end

    def get_person_happiness(happiness_map, people, idx) do
        person = Enum.at(people, idx)
        happiness = happiness_map[person]

        left = Enum.at(people, idx - 1)
        right_idx = Integer.mod((idx + 1), length(people))
        right = Enum.at(people, right_idx)

        happiness[left] + happiness[right]
    end

    def get_total_happiness(happiness_map, people) do
        Enum.sum(for idx <- 0..length(people) - 1 do
            get_person_happiness(happiness_map, people, idx)
        end)
    end

    # Since we're dealing with a circular list, not all permutations are needed
    # but this seemed easier and good enough for this problem
    def permutations([]), do: [[]]
    def permutations(list) do
        for h <- list, t <- permutations(list -- [h]), do: [h | t]
    end

    def find_most_happiness(happiness_map) do
        people = happiness_map |> Map.keys

        solutions = for variant <- permutations(people) do
            {get_total_happiness(happiness_map, variant), variant}
        end

        solutions |> Enum.sort |> List.last
    end

    def add_myself(happiness_map) do
        people = happiness_map |> Map.keys
        happiness_map = put_in(happiness_map["Me"], %{})
        Enum.reduce(people, happiness_map, fn person, acc ->
            acc = put_in(acc["Me"][person], 0)
            put_in(acc[person]["Me"], 0)
        end)
    end

    def part1(input) do
        input |> parse_input |> find_most_happiness
    end

    def part2(input) do
        input |> parse_input |> add_myself |> find_most_happiness
    end
end

input = File.read!("day13.in")
# input = File.read!("day13.example.in")

Day13.part1(input) |> IO.inspect
Day13.part2(input) |> IO.inspect
