defmodule Impl do
  def permutations([h | rest], callback), do: permutations(rest, [h], callback)
  defp permutations([], acc, _callback), do: acc

  defp permutations([h | rest], acc, callback),
    do: permutations(rest, Enum.flat_map(acc, &callback.(&1, h)), callback)
end

"day7_input"
|> File.stream!(:line)
|> Enum.reduce({0, 0}, fn line, {p1, p2} ->
  {test_value, ": " <> ints} = Integer.parse(line)
  ints = ints |> String.split(~r/\s/, trim: true) |> Enum.map(&String.to_integer/1)
  permutations = Impl.permutations(ints, &[&1 + &2, &1 * &2])

  p1 =
    if Enum.any?(permutations, &(&1 == test_value)) do
      p1 + test_value
    else
      p1
    end

  permutations =
    Impl.permutations(
      ints,
      &[&1 + &2, &1 * &2, String.to_integer(Integer.to_string(&1) <> Integer.to_string(&2))]
    )

  p2 =
    if Enum.any?(permutations, &(&1 == test_value)) do
      p2 + test_value
    else
      p2
    end

  {p1, p2}
end)
|> IO.inspect()
