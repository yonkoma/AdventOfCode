defmodule Day7 do
	def parse_filetree do
		File.read!("input.txt")
		|> String.split("\n", trim: true)
		|> Enum.drop(1)
		|> Enum.reduce({["/"], %{"/" => %{}}}, fn cmd, {dir_stack, filetree} ->
			case cmd do
				<<"$ cd ..">> -> {Enum.drop(dir_stack, -1), filetree}
				<<"$ cd ", new_dir::binary>> -> {dir_stack ++ [new_dir], filetree}
				<<"$ ls", _::binary>> -> {dir_stack, filetree}
				<<"dir ", dir_name::binary>> -> {dir_stack, put_in(filetree, dir_stack ++ [dir_name], %{})}
				file_str -> 
					[size, name] = String.split(file_str)
					{dir_stack, put_in(filetree, dir_stack ++ [name], String.to_integer(size))}
			end
		end)
		|> elem(1)
	end

	def convert_to_size_list filetree do
		Map.values(filetree)
		|> Enum.reduce({0, []}, fn
			folder, {total, size_list} when is_map(folder) -> 
				{folder_size, folder_size_list} = convert_to_size_list(folder)
				{folder_size + total, [folder_size | folder_size_list] ++ size_list}
			size, {total, size_list} -> {size + total, size_list}
		end)
	end

	def part1 do
		parse_filetree()
		|> convert_to_size_list()
		|> elem(1)
		|> Enum.filter(&(&1 <= 100_000))
		|> Enum.sum
		|> IO.inspect
	end

	def part2 do
		disk_size = 70_000_000
		space_needed = 30_000_000
		{total_used, size_list} = parse_filetree() |> convert_to_size_list()
		space_to_free = space_needed - (disk_size - total_used)

		Enum.sort(size_list)
		|> Enum.find(&(&1 >= space_to_free))
		|> IO.inspect()
	end
end

Day7.part1
Day7.part2