defmodule Day5 do

	def run_move_part1 {0, _, _}, state do
		state
	end
	def run_move_part1 {count, from, to}, state do
		[box | old_stack] = elem(state, from)
		new_stack = [box | elem(state, to)]

		new_state = put_elem(state, from, old_stack)
		|> put_elem(to, new_stack)

		run_move_part1 {count - 1, from, to}, new_state
	end

	def run_move_part2 {count, from, to}, state do
		{boxes, old_stack} = Enum.split(elem(state, from), count)
		new_stack = boxes ++ elem(state, to)

		put_elem(state, from, old_stack)
		|> put_elem(to, new_stack)
	end

	def main do
		input = File.read!("input.txt") |> String.trim_trailing
		[boxes_str, moves_str] = String.split(input, "\n\n") |> Enum.map(&String.split(&1, "\n"))

		boxes = Enum.drop(boxes_str, -1) |> Enum.map(fn row ->
			String.slice(row, 1..-1//4)
			|> String.codepoints
		end)
		|> Enum.zip_with(&(&1))
		|> Enum.map(fn stack -> Enum.reject(stack, &(&1 == " ")) end)
		|> List.to_tuple

		moves = Enum.map(moves_str, fn move -> 
			Regex.run(~r/move (\d+) from (\d+) to (\d+)/, move, capture: :all_but_first)
			|> Enum.map(&String.to_integer/1)
			|> List.to_tuple
		end)
		|> Enum.map(fn {count, from, to} -> {count, from - 1, to - 1} end)

		Enum.reduce(moves, boxes, &run_move_part2/2)
		|> Tuple.to_list
		|> Enum.map(&List.first/1)
		|> List.to_string
		|> IO.inspect
	end
end

Day5.main