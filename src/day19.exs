# Day 19: Medicine for Rudolph
# https://adventofcode.com/2019/day/19

defmodule Day19 do
  def parse_combinations(combinations) do
    combinations |> String.split("\n") |> Enum.map(&(String.split(&1, " => ")))

  end

  def parse_input(input) do
    [pairs, molecule] = input |> String.split("\n\n")
    replacemements = pairs |> String.split("\n")
                           |> Enum.map(&(String.split(&1, " => ")))
    {molecule, replacemements}
  end

  def find(string, substring) do
    # Return all positions of substring in string
    strlen = String.length(string)
    sublen = String.length(substring)
    range = 0..(strlen - sublen)

    Enum.reduce(range, [], fn pos, acc ->
      if String.slice(string, pos, sublen) == substring do
        acc ++ [pos]
      else
        acc
      end
    end)
  end

  def replace(molecule, pos, from, to) do
    last_pos = String.length(molecule) - 1

    left = if pos > 0 do
      String.slice(molecule, 0..pos - 1)
    else
      ""
    end

    right = if pos < last_pos do
      from_len = String.length(from)
      String.slice(molecule, pos + from_len..last_pos)
    else
      ""
    end

    left <> to <> right
  end

  def apply_replacement(molecule, [from, to]) do
    find(molecule, from) |> Enum.map(&replace(molecule, &1, from, to))
  end

  def apply_replacements(replacements, molecule) do
    Enum.map(replacements, &(apply_replacement(molecule, &1))) |> List.flatten
  end

  def part1(input) do
    {molecule, replacements} = parse_input(input)
    replacements |> apply_replacements(molecule)
                 |> Enum.uniq
                 |> Enum.count
  end

  def replace_longest(molecule, replacements) do
    replacements |> Enum.sort_by(&(-String.length(List.last(&1))))
                 |> Stream.map(fn [from, to] ->
                      if String.contains?(molecule, to) do
                        String.replace(molecule, to, from, global: false)
                      end
                    end)
                 |> Stream.filter(&is_bitstring/1)
                 |> Stream.take(1)
                 |> Enum.to_list
                 |> List.first
  end

  def part2_loop(molecule, replacements, count) do
    if molecule == "e" do
      count
    else
      next_molecule = replace_longest(molecule, replacements)
      part2_loop(next_molecule, replacements, count + 1)
    end
  end

  def part2(input) do
    {molecule, replacements} = parse_input(input)
    part2_loop(molecule, replacements, 0)
  end
end

# input = File.read!("day19.example.in")
input = File.read!("day19.in")

Day19.part1(input) |> IO.inspect
Day19.part2(input) |> IO.inspect
