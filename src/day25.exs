defmodule Day25 do
  @doc """
  Given a code, returns the next code.
  """
  def next(code), do: rem(code * 252533, 33554393)

  @doc """
  Given a starting code, returns a code n steps after it.
  """
  def nth(code, n) do
    Enum.reduce(1..(n - 1), code, fn _, c -> next(c) end)
  end

  @doc """
  Enum.sum(1..n), but faster
  """
  def sum_1_n(n) when n >= 0 do
    div(n * (n + 1), 2)
  end

  @doc """
  Enum.sum(n..m), but faster
  """
  def sum_n_m(n, m) when m >= n do
    sum_1_n(m) - sum_1_n(n - 1)
  end

  @doc """
  Given x,y coordinates in the grid, returns the ordinal number of that position
  according to the diagonal filling order.
  """
  def pos({x, y}) when x > 0 and y > 0 do
    # First find value at {1, y}
    y1 = sum_1_n(y - 1) + 1
    dx =
      if x == 1 do
        0
      else
        sum_n_m(y + 1, y + x - 1)
      end
    y1 + dx
  end

  def part1(first_code, coordinates) do
    nth(first_code, pos(coordinates))
  end
end

Day25.part1(20151125, {3083, 2978})
