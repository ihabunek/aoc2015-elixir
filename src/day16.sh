# Day 16: Aunt Sue
# https://adventofcode.com/2015/day/16

# This does not require programming.

# Grep solution for part 1:
#
cat day16.in  \
  | grep -v "children: [^3]" \
  | grep -v "cats: [^7]" \
  | grep -v "samoyeds: [^2]" \
  | grep -v "pomeranians: [^3]" \
  | grep -v "akitas: [^0]" \
  | grep -v "vizslas: [^0]" \
  | grep -v "goldfish: [^5]" \
  | grep -v "trees: [^3]" \
  | grep -v "cars: [^2]" \
  | grep -v "perfumes: [^1]"\
  | grep -v "perfumes: 10"

# Grep solution for part 2:
#
cat day16.in  \
  | grep -v "children: [^3]" \
  | grep -v "cats: [^8-9]" \
  | grep -v "samoyeds: [^2]" \
  | grep -v "pomeranians: [^1-2]" \
  | grep -v "akitas: [^0]" \
  | grep -v "vizslas: [^0]" \
  | grep -v "goldfish: [^1-4]" \
  | grep -v "trees: [^4-9]" \
  | grep -v "cars: [^2]" \
  | grep -v "perfumes: [^1]"
