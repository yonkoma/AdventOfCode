input = File.read!("input.txt")
|> String.trim
|> String.split("\n")
|> Enum.map(fn <<theirs, " ", mine>> -> {theirs - ?A, mine - ?X} end)

plays = Enum.map(input, fn {a, b} -> b + a end)
|> Enum.map(&rem(&1, 3))
|> Enum.map(fn 0 -> 3; x -> x end)
|> Enum.sum

wins = Enum.map(input, fn {_, b} -> b * 3 end)
|> Enum.sum

wins + plays
|> IO.inspect

# Initial solution
# mapping = %{"A" => 1, "B" => 2, "C" => 3, "X" => 0, "Y" => 1, "Z" => 2}
# input = File.read!("input.txt") |> String.split("\n") |> Enum.map(&String.split/1) |> Enum.map(fn x -> Enum.map(x, &(mapping[&1])) end) |> Enum.reject(&(&1 == []))
# plays = Enum.map(input, fn [a, b] -> b + a - 1 end) |> Enum.map(&rem(&1, 3)) |> Enum.map(fn 0 -> 3; x -> x end) |> Enum.sum
# wins = Enum.map(input, fn [_, b] -> b * 3 end) |> Enum.sum
# wins + plays
# |> IO.inspect