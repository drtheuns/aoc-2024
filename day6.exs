grid =
  "day6_input"
  |> File.stream!(:line)
  |> Stream.with_index()
  |> Enum.reduce(%{}, fn {line, line_idx}, acc ->
    line
    |> String.split("", trim: true)
    |> Stream.with_index()
    |> Enum.reduce(acc, fn {col, col_idx}, acc ->
      if col == "^", do: Process.put("start", {line_idx, col_idx})
      Map.put(acc, {line_idx, col_idx}, col)
    end)
  end)

defmodule Impl do
  def steps(grid, pos, dir \\ :up, acc \\ MapSet.new()) do
    case advance(grid, pos, dir) do
      {:cont, pos, dir} -> steps(grid, pos, dir, MapSet.put(acc, pos))
      :done -> acc
    end
  end

  def loops?(grid, pos) do
    # Slow impl, but I don't care.
    loops?(grid, pos, :up, MapSet.new())
  end

  def loops?(grid, pos, dir, route) do
    case advance(grid, pos, dir) do
      {:cont, new_pos, new_dir} ->
        # We were at pos, and went in new_dir. If, in the future, we reach the
        # same pos and go in the same direction, then we're going in circles.
        step = {pos, new_dir}

        case MapSet.member?(route, step) do
          true -> true
          false -> loops?(grid, new_pos, new_dir, MapSet.put(route, step))
        end

      :done ->
        false
    end
  end

  defp advance(grid, pos, dir) do
    next_pos = next(dir, pos)

    case Map.get(grid, next_pos) do
      "#" -> advance(grid, pos, next_direction(dir))
      nil -> :done
      _ -> {:cont, next_pos, dir}
    end
  end

  defp next(:up, {line_idx, col_idx}), do: {line_idx - 1, col_idx}
  defp next(:right, {line_idx, col_idx}), do: {line_idx, col_idx + 1}
  defp next(:down, {line_idx, col_idx}), do: {line_idx + 1, col_idx}
  defp next(:left, {line_idx, col_idx}), do: {line_idx, col_idx - 1}

  defp next_direction(:up), do: :right
  defp next_direction(:right), do: :down
  defp next_direction(:down), do: :left
  defp next_direction(:left), do: :up
end

start = Process.get("start")
steps = Impl.steps(grid, start)

# part 1
IO.puts(MapSet.size(steps))
# part 2
Enum.reduce(steps, 0, fn step, total ->
  new_grid = Map.put(grid, step, "#")

  case Impl.loops?(new_grid, start) do
    true -> total + 1
    false -> total
  end
end)
|> IO.puts()
