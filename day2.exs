defmodule Checker do
  import Bitwise

  # Part 1: 0 = unsafe, 1 = safe.
  def safety_score([h | t]) when is_integer(h) do
    safety_score(t, h, nil)
  end

  defp safety_score([], _prev, _diff), do: 1

  defp safety_score([num | rest], prev, diff) when is_integer(num) and is_integer(prev) do
    distance = prev - num
    abs = abs(distance)

    cond do
      abs > 3 or abs < 1 -> 0
      # Not the same sign, therefore not the same direction, so unsafe.
      diff != nil and bxor(diff, distance) < 0 -> 0
      true -> safety_score(rest, num, distance)
    end
  end

  # Part 2
  def safety_score_dampened(list) do
    # lazy brute force approach.
    variations = Stream.map(0..length(list), fn i -> List.delete_at(list, i) end)
    all = Stream.concat([list], variations)

    Enum.reduce_while(all, 0, fn entry, _ ->
      case safety_score(entry) do
        1 -> {:halt, 1}
        0 -> {:cont, 0}
      end
    end)
  end
end

{p1, p2} =
  "day2_input"
  |> File.stream!(:line)
  |> Enum.reduce({0, 0}, fn report, {p1, p2} ->
    levels =
      report
      |> String.split(" ", trim: true)
      |> Enum.map(fn num -> elem(Integer.parse(num), 0) end)

    {
      p1 + Checker.safety_score(levels),
      p2 + Checker.safety_score_dampened(levels)
    }
  end)

IO.puts(p1)
IO.puts(p2)
