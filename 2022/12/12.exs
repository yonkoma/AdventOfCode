defmodule Day12 do
	def parse_input do
		File.read!("input.txt")
		|> String.split("\n", trim: true)
		|> Enum.map(&String.to_charlist/1)
		|> Enum.map(&Enum.with_index/1)
		|> Enum.with_index
		|> Enum.map(fn {row, row_index} ->
			Enum.map(row, fn {elevation, col_index} ->
				{{row_index, col_index}, elevation}
			end)
		end)
		|> List.flatten
		|> Enum.reduce({%{}, 0, 0}, fn {coord, elevation}, {map, start, goal} ->
			case elevation do
				?S -> {Map.put(map, coord, 0), coord, goal}
				?E -> {Map.put(map, coord, 25), start, coord}
				letter -> {Map.put(map, coord, letter - ?a), start, goal}
			end
		end)
	end

	def get_adjacent map, {row, col} do
		[{row + 1, col}, {row - 1, col}, {row, col + 1}, {row, col - 1}]
		|> Enum.filter(&Map.has_key?(map, &1))
	end

	def find_path(_, dists, _, []) do
		dists
	end
	def find_path(map, dists, valid_step?, [step | frontier]) do
		new_steps =
			get_adjacent(map, step)
			|> Enum.filter(&valid_step?.(map[step], map[&1]))
			|> Enum.filter(&(dists[step] + 1 < dists[&1]))
		new_dists = Enum.reduce(new_steps, dists, &%{&2 | &1 => dists[step] + 1})
		find_path(map, new_dists, valid_step?, frontier ++ new_steps)
	end

	def part1 do
		{map, start, goal} = parse_input()
		dists = Map.new(Map.keys(map), &{&1, :infinity}) |> Map.put(start, 0)

		find_path(map, dists, &(&1 + 1 >= &2), [start])
		|> Map.fetch!(goal)
		|> IO.inspect
	end

	def part2 do
		{map, _, goal} = parse_input()
		dists = Map.new(Map.keys(map), &{&1, :infinity}) |> Map.put(goal, 0)

		find_path(map, dists, &(&1 - 1 <= &2), [goal])
		|> Map.filter(fn {coord, _} -> map[coord] == 0 end)
		|> Map.values
		|> Enum.min
		|> IO.inspect
	end

end

Day12.part1
Day12.part2