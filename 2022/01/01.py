#!/usr/bin/env python3

file = open("input.txt", "r")
lines = file.readlines()

calories = []
elf_calories = 0
for line in lines:
	if line == '\n':
		calories.append(elf_calories)
		elf_calories = 0
	else:
		elf_calories += int(line)

calories.sort(reverse=True)
print(calories[0]+calories[1]+calories[2])