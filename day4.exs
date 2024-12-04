defmodule Lead3 do
  def reduce([l1, l2, l3, l4 | rest], state, callback) do
    do_reduce([l1, l2, l3, l4], rest, state, callback)
  end

  defp do_reduce([], [], state, _callback), do: state

  defp do_reduce([_ | rest] = lines, [], state, callback) do
    do_reduce(rest, [], callback.(lines, state), callback)
  end

  defp do_reduce(lines, rest, state, callback) do
    state = callback.(lines, state)
    [next_lead | rest] = rest
    [_l1, l1, l2, l3] = lines
    do_reduce([l1, l2, l3, next_lead], rest, state, callback)
  end
end

defmodule BlockSearch do
  def search(lines, total) do
    total =
      total
      |> horizontal(lines)
      |> vertical(lines)
      |> diagonal_lr(lines)
      |> diagonal_rl(lines)

    case advance(lines) do
      {:ok, lines} -> search(lines, total)
      :done -> total
    end
  end

  def search_cross(lines, total) do
    total =
      case lines do
        [
          <<"M", _, "S", _::binary>>,
          <<_, "A", _::binary>>,
          <<"M", _, "S", _::binary>> | _
        ] ->
          total + 1

        [
          <<"M", _, "M", _::binary>>,
          <<_, "A", _::binary>>,
          <<"S", _, "S", _::binary>> | _
        ] ->
          total + 1

        [
          <<"S", _, "M", _::binary>>,
          <<_, "A", _::binary>>,
          <<"S", _, "M", _::binary>> | _
        ] ->
          total + 1

        [
          <<"S", _, "S", _::binary>>,
          <<_, "A", _::binary>>,
          <<"M", _, "M", _::binary>> | _
        ] ->
          total + 1

        _ ->
          total
      end

    case advance(lines) do
      {:ok, lines} -> search_cross(lines, total)
      :done -> total
    end
  end

  defp advance(["" | _]), do: :done
  defp advance(lines), do: {:ok, Enum.map(lines, fn <<_, l1::binary>> -> l1 end)}

  defp horizontal(total, ["XMAS" <> _ | _]), do: total + 1
  defp horizontal(total, ["SAMX" <> _ | _]), do: total + 1
  defp horizontal(total, _), do: total

  defp vertical(
         total,
         [
           "X" <> _,
           "M" <> _,
           "A" <> _,
           "S" <> _
         ]
       ),
       do: total + 1

  defp vertical(
         total,
         [
           "S" <> _,
           "A" <> _,
           "M" <> _,
           "X" <> _
         ]
       ),
       do: total + 1

  defp vertical(total, _), do: total

  defp diagonal_lr(
         total,
         [
           <<"X", _::binary>>,
           <<_, "M", _::binary>>,
           <<_, _, "A", _::binary>>,
           <<_, _, _, "S", _::binary>>
         ]
       ),
       do: total + 1

  defp diagonal_lr(
         total,
         [
           <<"S", _::binary>>,
           <<_, "A", _::binary>>,
           <<_, _, "M", _::binary>>,
           <<_, _, _, "X", _::binary>>
         ]
       ),
       do: total + 1

  defp diagonal_lr(total, _), do: total

  defp diagonal_rl(
         total,
         [
           <<_, _, _, "X", _::binary>>,
           <<_, _, "M", _::binary>>,
           <<_, "A", _::binary>>,
           <<"S", _::binary>>
         ]
       ),
       do: total + 1

  defp diagonal_rl(
         total,
         [
           <<_, _, _, "S", _::binary>>,
           <<_, _, "A", _::binary>>,
           <<_, "M", _::binary>>,
           <<"X", _::binary>>
         ]
       ),
       do: total + 1

  defp diagonal_rl(total, _), do: total
end

lines =
  "day4_input"
  |> File.stream!(:line)
  |> Enum.to_list()

# Part 1
lines
|> Lead3.reduce(0, &BlockSearch.search/2)
|> IO.puts()

# Part 2
lines
|> Lead3.reduce(0, &BlockSearch.search_cross/2)
|> IO.puts()
