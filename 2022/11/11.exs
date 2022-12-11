defmodule Day11 do
	def parse_input do
		File.read!("input.txt")
		|> String.split("\n\n", trim: true)
		|> Map.new(fn monkey -> 
			[<<"Monkey ", index_str, ":">>,
			<<"  Starting items: ", item_str::binary>>,
			<<"  Operation: new = ", op_str::binary>>,
			<<"  Test: divisible by ", test_str::binary>>,
			<<"    If true: throw to monkey ", true_dest_str>>,
			<<"    If false: throw to monkey ", false_dest_str>>]
			= String.split(monkey, "\n", trim: true)

			{index_str - ?0,
			%{:items => String.split(item_str, ", ") |> Enum.map(&String.to_integer/1),
			  :op => Code.eval_string("fn old -> " <> op_str <> " end") |> elem(0),
			  :div_test => String.to_integer(test_str),
			  :true => true_dest_str - ?0,
			  :false => false_dest_str - ?0,
			  :inspections => 0
			}}
		end)
	end

	def do_monkey_rounds monkeys, rounds, index \\ 0
	def do_monkey_rounds monkeys, 0, _ do
		monkeys
	end
	def do_monkey_rounds monkeys, rounds, index do
		cond do
			index >= Enum.count(monkeys) ->
				do_monkey_rounds(monkeys, rounds - 1, 0)
			Enum.empty?(monkeys[index][:items]) ->
				do_monkey_rounds(monkeys, rounds, index + 1)
			true ->
				[item | rest_items] = monkeys[index][:items]
				new_worry = monkeys[index][:op].(item) |> div(3)
				divisible = rem(new_worry, monkeys[index][:div_test]) == 0
				destination = monkeys[index][divisible]
				new_monkey_items = monkeys[destination][:items] ++ [new_worry]

				monkeys
				|> put_in([index, :items], rest_items)
				|> put_in([destination, :items], new_monkey_items)
				|> update_in([index, :inspections], &(&1 + 1))
				|> do_monkey_rounds(rounds, index)
		end
	end

	def part1 do
		parse_input()
		|> do_monkey_rounds(20)
		|> Enum.map(fn {_, monkey} -> monkey[:inspections] end)
		|> Enum.sort(:desc)
		|> Enum.take(2)
		|> Enum.product
		|> IO.inspect(charlists: :as_lists)
	end

	def part2 do
		parse_input()
	end
end

Day11.part1
# Day11.part2