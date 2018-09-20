# Day 6: Probably a Fire Hazard
# http://adventofcode.com/2015/day/6

defmodule Day06_1 do
  def toggle(s1, s2) do
    turn_on = MapSet.difference(s2, s1)
    turn_off = MapSet.intersection(s2, s1)
    s1 |> MapSet.union(turn_on) |> MapSet.difference(turn_off)
  end

  def parse_action(action) do
    case action do
      "turn on" -> &MapSet.union/2
      "turn off" -> &MapSet.difference/2
      "toggle" -> &toggle/2
    end
  end

  def parse_input(input) do
    pattern = ~r/(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/
    matches = Regex.scan(pattern, input)

    for [_, action, x1, y1, x2, y2] <- matches do
      [
        parse_action(action),
        String.to_integer(x1) .. String.to_integer(x2),
        String.to_integer(y1) .. String.to_integer(y2),
      ]
    end
  end

  def next_grid(grid, [action, xs, ys]) do
    points = MapSet.new(for x <- xs, y <- ys do {x, y} end)
    action.(grid, points)
  end

  def run_actions(grid, []) do
    grid
  end

  def run_actions(grid, actions) do
    run_actions(next_grid(grid, hd(actions)), tl(actions))
  end

  def part1(input) do
    MapSet.new |> run_actions(input |> parse_input)
               |> Enum.count
  end
end

defmodule Day06_2 do
  def parse_delta(delta) do
    case delta do
      "turn on" -> 1
      "turn off" -> -1
      "toggle" -> 2
    end
  end

  def parse_input(input) do
    pattern = ~r/(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/
    matches = Regex.scan(pattern, input)

    for [_, delta, x1, y1, x2, y2] <- matches do
      {
        parse_delta(delta),
        String.to_integer(x1),
        String.to_integer(x2),
        String.to_integer(y1),
        String.to_integer(y2),
      }
    end
  end

  def next_grid(grid, {delta, x1, x2, y1, y2}) do
    Enum.reduce(x1..x2, grid, fn x, grid ->
      Enum.reduce(y1..y2, grid, fn y, grid ->
        Map.update(grid, {x, y}, Enum.max([0, delta]), &(Enum.max([0, &1 + delta])))
      end)
    end)
  end

  def run_actions(grid, []) do
    grid
  end

  def run_actions(grid, actions) do
    run_actions(next_grid(grid, hd(actions)), tl(actions))
  end

  def part2(input) do
    %{} |> run_actions(input |> parse_input)
        |> Map.values
        |> Enum.sum
  end

end

input = File.read!("day06.in")

Day06_1.part1(input) |> IO.inspect  # ~30s, ~200MB mem
Day06_2.part2(input) |> IO.inspect  # ~60s, ~200MB mem

# (:erlang.memory(:total) / 1024 / 1024) |> Float.round(2) |> IO.inspect
