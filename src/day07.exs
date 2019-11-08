# Day 7: Some Assembly Required
# http://adventofcode.com/2015/day/7

use Bitwise

defmodule Cache do
  use Agent

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def clear do
    Agent.update(__MODULE__, fn _ -> %{} end)
  end

  def has?(key) do
    Agent.get(__MODULE__, &Map.has_key?(&1, key))
  end

  def get(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end

  def getall() do
    Agent.get(__MODULE__, & &1)
  end

  def set(key, value) do
    Agent.update(__MODULE__, &Map.put(&1, key, value))
  end
end

defmodule Day07 do
  def parse_symbol(input) do
    if Regex.match?(~r/^\d+$/, input) do
      input |> Integer.parse() |> elem(0)
    else
      input |> String.downcase() |> String.to_atom()
    end
  end

  def parse_not([_, signal]) do
    {:not, String.to_atom(signal)}
  end

  def parse_op([_, left, op, right]) do
    {
      parse_symbol(op),
      parse_symbol(left),
      parse_symbol(right)
    }
  end

  def parse_source(input) do
    symbol_pattern = ~r/^\w+$/
    not_pattern = ~r/^NOT (\w+)$/
    op_pattern = ~r/^(\w+) ([A-Z]+) (\w+)$/

    cond do
      Regex.match?(symbol_pattern, input) -> input |> parse_symbol
      Regex.match?(not_pattern, input) -> Regex.run(not_pattern, input) |> parse_not
      Regex.match?(op_pattern, input) -> Regex.run(op_pattern, input) |> parse_op
    end
  end

  def parse_line(line) do
    line_pattern = ~r/^(.+) -> (.+)$/
    [_, lhs, rhs] = Regex.run(line_pattern, line)
    target = String.to_atom(rhs)
    source = parse_source(lhs)
    {target, source}
  end

  def parse_input(input) do
    lines = String.split(input, "\n")

    Enum.reduce(lines, %{}, fn line, acc ->
      {target, source} = parse_line(line)
      Map.put(acc, target, source)
    end)
  end

  def run_op(defs, op) do
    case op do
      {:lshift, x, y} -> get_value_cached(defs, x) <<< get_value_cached(defs, y)
      {:rshift, x, y} -> get_value_cached(defs, x) >>> get_value_cached(defs, y)
      {:and, x, y} -> get_value_cached(defs, x) &&& get_value_cached(defs, y)
      {:or, x, y} -> get_value_cached(defs, x) ||| get_value_cached(defs, y)
      {:not, x} -> rem(65536 + ~~~get_value_cached(defs, x), 65536)
    end
  end

  def get_value(defs, signal) do
    if is_integer(signal) do
      signal
    else
      value = defs[signal]
      cond do
        is_integer(value) -> value
        is_atom(value) -> get_value_cached(defs, value)
        is_tuple(value) -> run_op(defs, value)
      end
    end
  end

  def get_value_cached(defs, signal) do
    if Cache.has?(signal) do
      Cache.get(signal)
    else
      value = get_value(defs, signal)
      Cache.set(signal, value)
      value
    end
  end

  def part1(input, start) do
    defs = input |> parse_input
    get_value_cached(defs, start)
  end

  def part2(input, start, override) do
    defs = input |> parse_input |> Map.merge(override)
    get_value_cached(defs, start)
  end
end

input = File.read!("day07.in")

Cache.start_link()
val1 = Day07.part1(input, :a) |> IO.inspect(label: "Part 1")
Cache.clear()
Day07.part2(input, :a, %{b: val1})  |> IO.inspect(label: "Part 2")
