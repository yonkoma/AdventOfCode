defmodule Day9 do
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

	def sign x do
		cond do
			x == 0 -> 0
			x > 0 -> 1
			x < 0 -> -1
		end
	end

	def do_movement motions, rope, visited \\ MapSet.new 
	def do_movement [], _, visited do 
		visited
	end
	def do_movement [{_, 0} | motions_tail], rope, visited do
		do_movement motions_tail, rope, visited
	end
	def do_movement [{direction, count} | motions_tail], [head | tail], visited do
		new_head = add(head, direction)
		new_tail = 
			Enum.map_reduce(tail, new_head, fn knot, prev_knot ->
				moved_knot = 
					case diff(prev_knot, knot) do
						{x, y} when abs(x) == 2 or abs(y) == 2 -> {sign(x), sign(y)}
						_ -> {0, 0}
					end
					|> add(knot)
				{moved_knot, moved_knot}
			end)
			|> elem(0)
		do_movement [{direction, count - 1} | motions_tail], [new_head | new_tail], MapSet.put(visited, Enum.take(new_tail, -1))
	end

	def part1 do
		parse_input()
		|> do_movement(List.duplicate({0, 0}, 2))
		|> Enum.count
		|> IO.inspect
	end

	def part2 do
		parse_input()
		|> do_movement(List.duplicate({0, 0}, 10))
		|> Enum.count
		|> IO.inspect
	end
end

Day9.part1
Day9.part2