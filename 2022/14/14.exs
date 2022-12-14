defmodule Day14 do
	def parse_input() do
		File.read!("input.txt")
		|> String.split("\n", trim: true)
		|> Enum.map(fn line -> 
			String.split(line, " -> ")
			|> Enum.map(fn point ->
				String.split(point, ",")
				|> Enum.map(&String.to_integer/1)
				|> List.to_tuple
			end)
		end)
	end

	def sign(x) do
		cond do
			x == 0 -> 0
			x > 0 -> 1
			x < 0 -> -1
		end
	end

	def make_rock_line({from_x, from_y}, {to_x, to_y}) do
		if from_x != to_x do
			for x <- from_x..to_x//sign(to_x - from_x) do
				{x, from_y}
			end
		else
			for y <- from_y..to_y//sign(to_y - from_y) do
				{from_x, y}
			end
		end
		|> Map.new(&{&1, "#"})
	end

	def make_rock_map(paths) when is_list(paths) do
		make_rock_map(%{}, paths)
	end

	def make_rock_map(rocks, []) do
		rocks
	end
	def make_rock_map(rocks, [path | rest]) do
		Enum.reduce(tl(path), {hd(path), rocks}, fn coord, {prev_coord, rock_acc} ->
			{coord, Map.merge(rock_acc, make_rock_line(prev_coord, coord))}
		end)
		|> elem(1)
		|> make_rock_map(rest)
	end

	def rock_bottom(rocks) do
		Map.keys(rocks)
		|> Enum.map(&elem(&1, 1))
		|> Enum.max
	end

	def pour_sand(rocks) do
		pour_sand(rocks, rock_bottom(rocks))
	end
	def pour_sand(rocks, bottom) do
		pour_sand(rocks, bottom, {500, 0})
	end
	def pour_sand(map, bottom, {_, sand_y}) when sand_y > bottom do
		map
	end
	def pour_sand(map, bottom, {sand_x, sand_y}) do
		new_sand =
			[{sand_x, sand_y + 1}, {sand_x - 1, sand_y + 1}, {sand_x + 1, sand_y + 1}]
			|> Enum.find(& not Map.has_key?(map, &1))
		if new_sand != nil do
			pour_sand(map, bottom, new_sand)
		else
			Map.put(map, {sand_x, sand_y}, "o")
			|> pour_sand(bottom)
		end
	end

	def part1() do
		parse_input()
		|> make_rock_map()
		|> pour_sand()
		|> Map.values
		|> Enum.count(& &1 == "o")
		|> IO.inspect
	end
end

Day14.part1
