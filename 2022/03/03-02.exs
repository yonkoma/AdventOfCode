File.read!("input.txt")
|> String.trim
|> String.split("\n")
|> Enum.map(&String.to_charlist/1)
|> Enum.map(fn str -> 
	Enum.map(str, fn ch -> 
		if ch in ?A..?Z,
		do: ch - ?A + 27,
		else: ch - ?a + 1
	end)
	|> MapSet.new
end)
|> Enum.chunk_every(3)
|> Enum.map(fn group ->
	Enum.reduce(group, &MapSet.intersection/2)
	|> MapSet.to_list
	|> List.first
end)
|> Enum.sum
|> IO.inspect