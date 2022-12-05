defmodule Day04 do
	def contains a, b do
		(a.first <= b.first and a.last >= b.last)
		or (b.first <= a.first and b.last >= a.last)
	end

	def main do
		File.read!("input.txt")
		|> String.trim
		|> String.split("\n")
		|> Enum.map(fn pair -> 
			[a, b, c, d] = Regex.split(~r/[-,]/, pair) |> Enum.map(&String.to_integer/1)
			not Range.disjoint?(a..b, c..d)
			# contains(a..b, c..d)
		end)
		|> Enum.count(&(&1))
		|> IO.inspect
	end
end

Day04.main