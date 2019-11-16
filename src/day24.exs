defmodule Combinatorics do
  def combinations(0, _), do: [[]]
  def combinations(_, []), do: []

  def combinations(len, [h | t]) do
    for(l <- combinations(len - 1, t), do: [h | l]) ++ combinations(len, t)
  end
end

defmodule Day24 do
  def product(list) do
    Enum.reduce(list, &*/2)
  end

  def min_len(input, target_weight) do
    1..(Enum.count(input))
    |> Stream.map(& Combinatorics.combinations(&1, input))
    |> Stream.concat()
    |> Stream.filter(&(Enum.sum(&1) == target_weight))
    |> Enum.take(1)
    |> List.first()
    |> Enum.count()
  end

  def solve(input, group_count) do
    target_weight = Enum.sum(input) / group_count
    len = min_len(input, target_weight)

    Combinatorics.combinations(len, input)
    |> Enum.filter(&(Enum.sum(&1) == target_weight))
    |> Enum.map(&product/1)
    |> Enum.min()
  end
end

input = [1, 2, 3, 7, 11, 13, 17, 19, 23, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113]

Day24.solve(input, 3) |> IO.inspect(label: "Part 1")
Day24.solve(input, 4) |> IO.inspect(label: "Part 2")
