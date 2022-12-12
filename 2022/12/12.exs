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

	def find_path(_, goal, path) when hd(path) == goal do
		path
	end
	def find_path(map, goal, path) do
		pos = hd(path)
		
		goal_paths =
			get_adjacent(map, pos)
			|> Enum.filter(&(Map.fetch!(map, &1) >= (Map.fetch!(map, pos) - 1)))
			|> Enum.reject(&(&1 in path))
			|> Enum.reduce([], fn next_step, path_acc ->
				case find_path(map, goal, [next_step | path]) do
					:fail -> path_acc
					goal_path -> [goal_path | path_acc]
				end
			end)
			|> Enum.sort(& length(&1) <+ length(&2))

		if Enum.empty?(goal_paths) do
			:fail
		else			
			hd(goal_paths)
		end
	end

	def part1 do
		{map, start, goal} = parse_input()
		find_path(map, start, [goal])
		|> Enum.drop(1)
		|> length()
		|> IO.inspect
	end

end

# Day12.part1
# Day12.part2