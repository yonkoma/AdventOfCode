defmodule Day13 do
	def parse_input() do
		File.read!("input.txt")
		|> String.split("\n\n", trim: true)
		|> Enum.map(fn pair -> 
			String.split(pair, "\n", trim: true)
			|> Enum.map(&(Code.eval_string(&1) |> elem(0)))
		end)
	end

	def compare([], []) do
		:eq
	end
	def compare([], _) do
		:lt
	end
	def compare(_, []) do
		:gt
	end
	def compare([left | left_rest], [right | right_rest]) do
		comp_result = compare(left, right)
		if comp_result == :eq do
			compare(left_rest, right_rest)
		else
			comp_result
		end
	end
	def compare(left, right) do
		cond do
			is_list(left) or is_list(right) -> compare(List.wrap(left), List.wrap(right))
			left < right -> :lt
			left > right -> :gt
			left == right -> :eq
		end
	end

	def sort_fun(left, right) do
		case compare(left, right) do
			:lt -> true
			_ -> false
		end
	end

	def part1() do
		parse_input()
		|> Enum.map(fn [left, right] -> sort_fun(left, right) end)
		|> Enum.with_index(1)
		|> Enum.filter(&elem(&1, 0))
		|> Enum.unzip
		|> elem(1)
		|> Enum.sum
		|> IO.inspect
	end

	def part2() do
		sorted_packets =
			parse_input()
			|> Enum.reduce([[[2]], [[6]]], fn [left, right], acc ->
				[left, right] ++ acc
			end)
			|> Enum.sort(&sort_fun/2)

		index_a = Enum.find_index(sorted_packets, &(&1 == [[2]]))
		index_b = Enum.find_index(sorted_packets, &(&1 == [[6]]))
		(index_a + 1) * (index_b + 1)
		|> IO.inspect
	end

end

Day13.part1
Day13.part2