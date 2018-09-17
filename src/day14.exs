# Day 14: Reindeer Olympics
# https://adventofcode.com/2015/day/14

defmodule Day14 do
    def distance_traveled(reindeer, duration) do
        # Returns the distance travelled by a reindeer in <duration> seconds
        {name, speed, fly_time, rest_time} = reindeer

        cycle = Stream.cycle([{fly_time, speed}, {rest_time, 0}])
        distances = Stream.transform(cycle, 0, fn {time, speed}, time_elapsed ->
            next_time = time_elapsed + time
            remaining_time = duration - time_elapsed
            cond do
                next_time <= duration -> {[time * speed], next_time}
                remaining_time > 0 -> {[remaining_time * speed], time_elapsed + remaining_time}
                true -> {:halt, time_elapsed}
            end
        end)

        {(distances |> Enum.sum), name}
    end

    def part1(input, total_time) do
        input |> Enum.map(&(distance_traveled(&1, total_time)))
              |> Enum.sort
    end

    def part2(input, total_time) do
        Enum.reduce(0..total_time, %{}, fn duration, acc ->
            results = input |> Enum.map(&(distance_traveled(&1, duration)))
            best_distance = results |> Enum.map(fn {distance, _} -> distance end)
                                    |> Enum.max
            winners = results |> Enum.filter(fn {distance, _} -> distance == best_distance end)
                              |> Enum.map(fn {_, name} -> name end)

            Enum.reduce(winners, acc, fn winner, acc ->
                Map.update(acc, winner, 0, &(&1 + 1))
            end)
        end)
    end
end

# example_input = [
#     {"Comet", 14, 10, 127},
#     {"Dancer", 16, 11, 162},
# ]

# Day14.part1(example_input, 1000) |> IO.inspect
# Day14.part2(example_input, 1000) |> IO.inspect(limit: :infinity)


# Can't be bothered with regex
input = [
    {"Vixen",    8,  8,  53},
    {"Blitzen", 13,  4,  49},
    {"Rudolph", 20,  7, 132},
    {"Cupid",   12,  4,  43},
    {"Donner",   9,  5,  38},
    {"Dasher",  10,  4,  37},
    {"Comet",    3, 37,  76},
    {"Prancer",  9, 12,  97},
    {"Dancer",  37,  1,  36},
]

Day14.part1(input, 2503) |> IO.inspect
Day14.part2(input, 2503) |> IO.inspect
