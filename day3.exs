# Part 1.

content = File.read!("day3_input")

Regex.scan(~r/mul\((\d+),(\d+)\)/, content, capture: :all_but_first)
|> Enum.reduce(0, fn [lhs, rhs], acc -> acc + String.to_integer(lhs) * String.to_integer(rhs) end)
|> IO.puts()

# Part 2

defmodule Interpreter do
  def interpret(instructions), do: execute(instructions, 0)

  defp execute([], acc), do: acc

  defp execute([["mul", lhs, rhs] | rest], acc),
    do: execute(rest, acc + String.to_integer(lhs) * String.to_integer(rhs))

  # I'm not gonna bother trying to remove these empty strings from the regex matches.
  defp execute([[_, _, _, "don't"] | rest], acc), do: ignore(rest, acc)
  defp execute([_ | rest], acc), do: execute(rest, acc)

  defp ignore([[_, _, _, _, "do"] | rest], acc), do: execute(rest, acc)
  defp ignore([_ | rest], acc), do: ignore(rest, acc)
  defp ignore([], acc), do: acc
end

mul = "(mul)\\((\\d+),(\\d+)\\)"
dont = "(don't)\\(\\)"
do_ = "(do)\\(\\)"
regex = Regex.compile!("#{mul}|#{dont}|#{do_}")

Regex.scan(regex, content, capture: :all_but_first)
|> Interpreter.interpret()
|> IO.puts()
