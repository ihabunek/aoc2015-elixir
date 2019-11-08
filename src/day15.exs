defmodule Day15 do
  def get_permutations(max) do
    Stream.flat_map(1..max, fn a ->
      Stream.flat_map(1..max, fn b ->
        Stream.flat_map(1..max, fn c ->
          Stream.flat_map(1..max, fn d ->
            if a + b + c + d == max,
              do: [%{sprinkles: a, butterscotch: b, chocolate: c, candy: d}],
              else: []
          end)
        end)
      end)
    end)
  end

  def get_calories(ingredients, quantities) do
    for {name, amount} <- quantities do
      ingredients[name][:calories] * amount
    end
    |> Enum.sum()
  end

  def get_score(ingredients, quantities) do
    for prop <- [:capacity, :durability, :flavor, :texture] do
      for {name, amount} <- quantities do
        ingredients[name][prop] * amount
      end
      |> Enum.sum()
      |> max(0)
    end
    |> Enum.reduce(&*/2)
  end

  def part1(ingredients) do
    get_permutations(100)
    |> Stream.map(fn quantities -> get_score(ingredients, quantities) end)
    |> Enum.max
  end

  def part2(ingredients) do
    get_permutations(100)
    |> Stream.filter(fn quantities -> get_calories(ingredients, quantities) == 500 end)
    |> Stream.map(fn quantities -> get_score(ingredients, quantities) end)
    |> Enum.max
  end
end

# Don't feel like parsing text again
ingredients = %{
  sprinkles: %{capacity: 2, durability: 0, flavor: -2, texture: 0, calories: 3},
  butterscotch: %{capacity: 0, durability: 5, flavor: -3, texture: 0, calories: 3},
  chocolate: %{capacity: 0, durability: 0, flavor: 5, texture: -1, calories: 8},
  candy: %{capacity: 0, durability: -1, flavor: 0, texture: 5, calories: 8}
}

Day15.part1(ingredients) |> IO.inspect(label: "Part 1")
Day15.part2(ingredients) |> IO.inspect(label: "Part 2")
