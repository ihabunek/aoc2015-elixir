# Day 9: All in a Single Night
# https://adventofcode.com/2015/day/9


defmodule Day09 do
	def parse_line(line) do
		[_, from, to, distance] = Regex.run(~r/(\w+) to (\w+) = (\d+)/, line)
		{
			String.to_atom(from),
			String.to_atom(to),
			String.to_integer(distance),
		}
	end

	def reduce_to_map(distances) do
		Enum.reduce(distances, %{}, fn {src, dest, dist}, acc -> 
			acc = if not Map.has_key?(acc, src) do Map.put(acc, src, %{}) else acc end
			acc = if not Map.has_key?(acc, dest) do Map.put(acc, dest, %{}) else acc end
			acc = put_in(acc[src][dest], dist)
			put_in(acc[dest][src], dist)
		end)
	end

	def parse_input(input) do
		input |> String.split("\n")
		      |> Enum.map(&parse_line/1)
		      |> reduce_to_map
	end

	def get_distance(distances, start, dest) do
		distances |> Map.get(start) |> Map.get(dest)
	end

	def find_paths(distances, start) do
		find_paths(distances, start, [], 0)
	end

	def find_paths(distances, start, visited, distance) do
		# Find places not yet visited to go to next
		next_places = distances |> Map.get(start) 
		                        |> Map.keys 
		                        |> Enum.filter(fn x -> x not in visited end)

		visited = visited ++ [start]
		
		if Enum.empty?(next_places) do
			{distance, visited}
		else
			Enum.map(next_places, &(find_paths(distances, &1, visited, distance + get_distance(distances, start, &1))))
		end
	end

	def find_all_paths(distances) do
    	paths = for start <- Map.keys(distances) do
    		find_paths(distances, start)
    	end

    	paths |> List.flatten # hacky hacky, learn proper branching recursion finally
    	      |> Enum.sort
	end

    def part1(input) do
    	input |> parse_input 
    	      |> find_all_paths 
    	      |> List.first
    end

    def part2(input) do
    	input |> parse_input 
    	      |> find_all_paths 
    	      |> List.last

    end
end

# input = File.read!("day09.example.in")
input = File.read!("day09.in")

Day09.part1(input) |> IO.inspect
Day09.part2(input) |> IO.inspect
