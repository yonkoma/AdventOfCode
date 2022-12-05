input = File.read!("input.txt")
|> String.trim
|> String.split("\n")
|> Enum.map(fn <<theirs, " ", mine>> -> {theirs - ?A, mine - ?X + 1} end)

plays = Enum.map(input, fn {_, b} -> b end)
|> Enum.sum

wins = Enum.map(input, fn {a, b} -> b - a end)
|> Enum.map(&Integer.mod(&1, 3) * 3)
|> Enum.sum

wins + plays
|> IO.inspect
# 10994