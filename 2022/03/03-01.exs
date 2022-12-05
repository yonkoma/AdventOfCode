File.read!("input.txt")
|> String.trim
|> String.split("\n")
|> Enum.map(fn str -> 
	charlist = String.to_charlist(str)
	priorities = Enum.map(str, fn ch -> 
		if ch in ?A..?Z do
			ch - ?A + 27
		else
			ch - ?a + 1
		end
	end)
	{left, right} = Enum.split(priorities, div(length(str), 2))
	MapSet.intersection(MapSet.new(left), MapSet.new(right))
	|> MapSet.to_list
	|> List.first
end)
|> Enum.sum
|> IO.inspect