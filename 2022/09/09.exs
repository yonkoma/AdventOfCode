defmodule Day8 do
	def parse_input do
		File.read!("input.txt")
		|> String.split("\n", trim: true)
		|> Enum.map(fn <<dir_ch, " ", steps::binary>> ->
			dir = case dir_ch do
				?U -> {0, 1}
				?D -> {0, -1}
				?R -> {1, 0}
				?L -> {-1, 0}
			end
			{dir, String.to_integer(steps)}
		end)
	end

	def add {coord_a_x, coord_a_y}, {coord_b_x, coord_b_y} do
		{coord_a_x + coord_b_x, coord_a_y + coord_b_y}
	end

	def diff {coord_a_x, coord_a_y}, {coord_b_x, coord_b_y} do
		{coord_a_x - coord_b_x, coord_a_y - coord_b_y}
	end

	def normalize x do
		div(x, abs(x))
	end

	def do_movement motions, rope \\ {{0, 0}, {0, 0}}, visited \\ MapSet.new 
	def do_movement [], _, visited do 
		visited
	end
	def do_movement [{_, 0} | motions_tail], rope, visited do
		do_movement motions_tail, rope, visited
	end
	def do_movement [{direction, count} | motions_tail], {head, tail}, visited do
		new_head = add(head, direction)
		new_tail =
			case diff(new_head, tail) do
				{x, y} when abs(x) == 2 -> {normalize(x), y}
				{x, y} when abs(y) == 2 -> {x, normalize(y)}
				_ -> {0, 0}
			end
			|> add(tail)
		do_movement [{direction, count - 1} | motions_tail], {new_head, new_tail}, MapSet.put(visited, new_tail)
	end

	def part1 do
		parse_input()
		|> do_movement()
		|> Enum.count
		|> IO.inspect
	end

	def part2 do
		parse_input()
	end
end

Day8.part1
# Day8.part2