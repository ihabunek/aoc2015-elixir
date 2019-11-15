defmodule Day22 do
  @spells %{
    magic_missile: 53,
    drain: 73,
    shield: 113,
    poison: 173,
    recharge: 229
  }

  def player_is_alive(state), do: state.player.hp > 0
  def boss_is_alive(state), do: state.boss.hp > 0

  def cast_spell(state, {spell, cost}) do
    state =
      state
      |> update_in([:player, :mana_spent], &(&1 + cost))
      |> update_in([:player, :mana], &(&1 - cost))

    case spell do
      :magic_missile ->
        update_in(state[:boss][:hp], &(&1 - 4))

      :drain ->
        state
        |> update_in([:boss, :hp], &(&1 - 2))
        |> update_in([:player, :hp], &(&1 + 2))

      :shield ->
        put_in(state[:effects][:shield], 6)

      :poison ->
        put_in(state[:effects][:poison], 6)

      :recharge ->
        put_in(state[:effects][:recharge], 5)
    end
  end

  def apply_effects(state) do
    # Remove damage reduction by default, it will be enabled by if shield effect is active
    state = put_in(state[:player][:damage_reduction], 0)

    # Apply each of the active effects
    Enum.reduce(state.effects, state, fn {effect, duration}, state ->
      state =
        case effect do
          :poison ->
            update_in(state[:boss][:hp], &(&1 - 3))

          :recharge ->
            update_in(state[:player][:mana], &(&1 + 101))

          :shield ->
            put_in(state[:player][:damage_reduction], 7)
        end

      # Decrease duration, remove expired effects
      if duration > 1 do
        update_in(state[:effects][effect], &(&1 - 1))
      else
        pop_in(state[:effects][effect]) |> elem(1)
      end
    end)
  end

  @doc """
  For a given state returns a list of {spell, cost} tuples of all spells which
  the player can cast.
  """
  def possible_spells(state) do
    @spells
    # Player has enough mana
    |> Enum.filter(&(elem(&1, 1) <= state.player.mana))
    # The effect is not already active
    |> Enum.filter(&(not Map.has_key?(state.effects, elem(&1, 0))))
  end

  @doc """
  Boss attacks the player if it's alive, takes no action if it's dead. Logically.
  """
  def boss_turn(state) do
    if boss_is_alive(state) do
      damage = state[:boss][:damage] - state[:player][:damage_reduction]
      update_in(state[:player][:hp], &(&1 - damage))
    else
      state
    end
  end

  def next_states(state) do
    possible_spells(state)
    |> Enum.map(&cast_spell(state, &1))
    |> Enum.map(&apply_effects/1)
    |> Enum.map(&boss_turn/1)
    |> Enum.filter(&player_is_alive/1)
  end

  # Boss cannot be killed :'(
  def loop([]), do: nil

  def loop(queue) do
    [state | rest] = Enum.sort_by(queue, &(&1.player.mana_spent + &1.boss.hp))
    state = apply_effects(state)

    # Win condition
    if state[:boss][:hp] <= 0 do
      state[:player][:mana_spent]
    else
      loop(Enum.uniq(rest ++ next_states(state)))
    end
  end

  def part1(state) do
    loop([state])
  end

  @doc """
  Part 2 is equivalent to increasing the boss's damage by 1.
  """
  def part2(state) do
    state = update_in(state[:boss][:damage], &(&1 + 1))
    loop([state])
  end
end

initial_state = %{
  boss: %{hp: 71, damage: 10},
  player: %{hp: 50, mana: 500, mana_spent: 0, damage_reduction: 0},
  effects: %{}
}

Day22.part1(initial_state) |> IO.inspect(label: "Part 1")
Day22.part2(initial_state) |> IO.inspect(label: "Part 2")
