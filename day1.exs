{left, right} =
  "day1_input"
  |> File.stream!(:line)
  |> Stream.map(fn line ->
    {left, rest} = Integer.parse(line)
    {right, "\n"} = Integer.parse(String.trim_leading(rest))
    {left, right}
  end)
  |> Enum.unzip()

left = Enum.sort(left)
right = Enum.sort(right)

p1 =
  Stream.zip(left, right)
  |> Enum.reduce(0, fn {left, right}, acc ->
    acc + abs(left - right)
  end)

IO.puts("answer to part one:")
IO.puts(p1)

frequencies = Enum.frequencies(right)

p2 =
  Enum.reduce(left, 0, fn num, acc ->
    acc + num * Map.get(frequencies, num, 0)
  end)

IO.puts("answer to part two:")
IO.puts(p2)
