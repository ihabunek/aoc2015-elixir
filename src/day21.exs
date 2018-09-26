# Day 21: RPG Simulator 20XX
# https://adventofcode.com/2015/day/21

defmodule Day21 do
  def possible_outfits(weapons, armors, rings) do
    # For a given catalogue returns all possible outfits for the player
    # 1 weapon, 0-1 armor, 0-2 rings
    possible_weapons = for w <- weapons do [w] end
    possible_armors = for a <- armors do [a] end ++ [[]]
    single_rings = for r <- rings do [r] end

    dual_rings = Enum.reduce(rings, [], fn r1, acc ->
      Enum.reduce(rings, acc, fn r2, acc ->
        combo = Enum.sort([r1, r2])
        if r1 != r2 and combo not in acc do
          acc ++ [combo]
        else
          acc
        end
      end)
    end)

    possible_rings = [[]] ++ single_rings ++ dual_rings

    outfits = for w <- possible_weapons do
      for a <- possible_armors do
        for r <- possible_rings do
          w ++ a ++ r
        end
      end
    end

    outfits
      |> Enum.reduce(&++/2)
      |> Enum.reduce(&++/2)
      |> Enum.map(fn items ->
            %{
              :items  => items |> Enum.map(&(&1[:name])),
              :price  => items |> Enum.map(&(&1[:price])) |> Enum.sum,
              :damage => items |> Enum.map(&(&1[:damage])) |> Enum.sum,
              :armor  => items |> Enum.map(&(&1[:armor])) |> Enum.sum,
            }
         end)
  end

  def turn(attacker, defender) do
    damage = max(attacker[:damage] - defender[:armor], 1)
    Map.update!(defender, :health, &(&1 - damage))
  end

  def battle(p1, p2) do
    # Battles between p1 and p2. p1 goes first. return the winner.
    p2 = turn(p1, p2)
    if p2[:health] <= 0 do
      p1
    else
      battle(p2, p1)
    end
  end

  def try_all_outfits(boss, weapons, armors, rings) do
    # For each possible outfit return the cost of the outfit and the name of the winner
    outfits = possible_outfits(weapons, armors, rings) |> Enum.sort_by(&(&1[:price]))
    player = %{:name => "player", :health => 100}
    for outfit <- outfits do
      winner = Map.merge(player, outfit) |> battle(boss)
      {outfit[:price], winner[:name]}
    end
  end

  def part1(boss, weapons, armors, rings) do
    try_all_outfits(boss, weapons, armors, rings)
      |> Enum.filter(&(elem(&1, 1) == "player"))
      |> List.first
      |> elem(0)
  end

  def part2(boss, weapons, armors, rings) do
    try_all_outfits(boss, weapons, armors, rings)
      |> Enum.filter(&(elem(&1, 1) == "boss"))
      |> List.last
      |> elem(0)
  end
end

boss = %{:name => "boss", :health => 104, :damage => 8, :armor => 1}

weapons = [
  %{:name => "Dagger",     :price =>   8, :damage => 4, :armor => 0},
  %{:name => "Shortsword", :price =>  10, :damage => 5, :armor => 0},
  %{:name => "Warhammer",  :price =>  25, :damage => 6, :armor => 0},
  %{:name => "Longsword",  :price =>  40, :damage => 7, :armor => 0},
  %{:name => "Greataxe",   :price =>  74, :damage => 8, :armor => 0},
]

armors = [
  %{:name => "Leather",    :price =>  13, :damage => 0, :armor => 1},
  %{:name => "Chainmail",  :price =>  31, :damage => 0, :armor => 2},
  %{:name => "Splintmail", :price =>  53, :damage => 0, :armor => 3},
  %{:name => "Bandedmail", :price =>  75, :damage => 0, :armor => 4},
  %{:name => "Platemail",  :price => 102, :damage => 0, :armor => 5},
]

rings = [
  %{:name => "Damage +1",  :price =>  25, :damage => 1, :armor => 0},
  %{:name => "Damage +2",  :price =>  50, :damage => 2, :armor => 0},
  %{:name => "Damage +3",  :price => 100, :damage => 3, :armor => 0},
  %{:name => "Defense +1", :price =>  20, :damage => 0, :armor => 1},
  %{:name => "Defense +2", :price =>  40, :damage => 0, :armor => 2},
  %{:name => "Defense +3", :price =>  80, :damage => 0, :armor => 3},
]

Day21.part1(boss, weapons, armors, rings) |> IO.inspect
Day21.part2(boss, weapons, armors, rings) |> IO.inspect
