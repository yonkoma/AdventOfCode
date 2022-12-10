defmodule Day10 do
	def parse_input do
		File.read!("input_2.txt")
		|> String.split("\n", trim: true)
		|> Enum.map(fn
			"noop" -> :noop
			"addx " <> value -> {:addx, String.to_integer(value)}
		end)
	end

	def generate_sprite_positions ops do
		Enum.reduce(ops, [1], fn op, register_history ->
			[register | _] = register_history
			case op do
				:noop -> [register | register_history]
				{:addx, value} -> [value + register, register] ++ register_history
			end
		end)
		|> Enum.reverse
		|> Enum.drop(-1)
		|> Enum.with_index(1)
	end

	def part1 do
		parse_input()
		|> generate_sprite_positions()
		|> Enum.slice(19..219//40)
		|> Enum.map(&Tuple.product/1)
		|> Enum.sum
		|> IO.inspect
	end

	def part2 do
		parse_input()
		|> generate_sprite_positions()
		|> Enum.reduce("", fn {sprite, cycle}, output ->
			crt_pos = Integer.mod(cycle - 1, 40)
			if crt_pos in (sprite - 1)..(sprite + 1),
			do: output <> "#",
			else: output <> "."
		end)
		|> String.to_charlist
		|> Enum.chunk_every(40)
		|> Enum.join("\n")
		|> IO.puts
	end
end

Day10.part1
Day10.part2