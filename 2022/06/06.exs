defmodule Day6 do
	@distinct_count 14
	def main do
		{head, tail} = 
		File.read!("input.txt")
		|> String.codepoints
		|> Enum.split(@distinct_count - 1)

		Enum.reduce_while(tail, {head, @distinct_count}, fn x, {prev_chars, count} ->
			chars = prev_chars ++ [x]
			if Enum.uniq(chars) != chars,
			do: {:cont, {Enum.drop(chars, 1), count + 1}},
			else: {:halt, count}
		end)
		|> IO.inspect
	end
end

Day6.main