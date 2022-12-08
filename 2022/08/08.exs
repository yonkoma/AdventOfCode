defmodule Day8 do
	def parse_input do
		File.read!("input.txt")
		|> String.split("\n", trim: true)
		|> Enum.map(fn row ->
			String.to_charlist(row)
			|> Enum.map(&(&1 - ?0))
		end)
	end

	def apply_in_directions trees, find_fun do
		left = find_fun.(trees) |> List.flatten
		right = Enum.map(trees, &Enum.reverse/1) |> find_fun.() |> Enum.map(&Enum.reverse/1) |> List.flatten
		top = Enum.zip_with(trees, &Function.identity/1) |> find_fun.() |> Enum.zip_with(&Function.identity/1) |> List.flatten
		bottom = Enum.zip_with(trees, &Function.identity/1) |> Enum.map(&Enum.reverse/1) |> find_fun.() |> Enum.map(&Enum.reverse/1) |> Enum.zip_with(&Function.identity/1) |> List.flatten
		[left, right, top, bottom]
	end

	def find_visible trees do
		Enum.map(trees, fn row ->
			Enum.map_reduce(row, -1, fn tree, tree_line ->
				if tree > tree_line,
				do: {true, tree},
				else: {false, tree_line}
			end)
			|> elem(0)
		end)
	end

	def find_scenic_score trees do
		init_scenery_state = 
			for i <- 0..9, into: %{} do
				{i, 0}
			end
		Enum.map(trees, fn row ->
			Enum.map_reduce(row, init_scenery_state, fn tree, scenery_state ->
				new_scenery =
					Map.new(scenery_state, fn {height, tree_count} ->
						if height > tree,
						do: {height, tree_count + 1},
						else: {height, 1}
					end)
				{scenery_state[tree], new_scenery}
			end)
			|> elem(0)
		end)
	end

	def part1 do
		parse_input()
		|> apply_in_directions(&find_visible/1)
		|> Enum.zip
		|> Enum.count(fn 
			{false, false, false, false} -> false
			_ -> true
		end)
		|> IO.inspect
	end

	def part2 do
		parse_input()
		|> apply_in_directions(&find_scenic_score/1)
		|> Enum.zip
		|> Enum.map(&Tuple.to_list/1)
		|> Enum.map(&Enum.product/1)
		|> Enum.max
		|> IO.inspect
	end
end

Day8.part1
Day8.part2