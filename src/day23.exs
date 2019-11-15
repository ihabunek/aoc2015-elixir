defmodule Day23 do
  @doc """
  Process is reverse engineered from pseudo-assembler input.
  """
  def process(1, b), do: b

  def process(a, b) do
    a = if rem(a , 2) == 0 do
      div(a, 2)
    else
      a * 3 + 1
    end

    process(a, b + 1)
  end
end

Day23.process(20895, 0) |> IO.inspect(label: "Part 1")
Day23.process(60975, 0) |> IO.inspect(label: "Part 2")
