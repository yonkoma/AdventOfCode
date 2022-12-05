File.read!("input.txt")
|> String.split("\n")
|> Enum.chunk_by(&(&1 == ""))
|> Enum.reject(&(&1 == [""]))
|> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)
|> Enum.map(&Enum.sum/1)
|> Enum.sort(:desc)
|> Enum.take(3)
|> Enum.sum
|> IO.inspect