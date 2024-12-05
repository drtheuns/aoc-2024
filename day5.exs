# Strictly speaking I don't need to convert anything other than the middle value
# to ints

defmodule Parser do
  def page_ordering_rules(lines), do: page_ordering_rules(lines, %{})

  defp page_ordering_rules([], rules), do: rules

  defp page_ordering_rules([rule | rest], rules) do
    {first, "|" <> rule} = Integer.parse(rule)
    {second, _} = Integer.parse(rule)
    rules = Map.update(rules, first, MapSet.new([second]), &MapSet.put(&1, second))
    page_ordering_rules(rest, rules)
  end

  def int_list(line, acc \\ [])
  def int_list("", acc), do: Enum.reverse(acc)

  def int_list("," <> str, acc), do: int_list(str, acc)

  def int_list(str, acc) do
    {int, rest} = Integer.parse(str)
    int_list(rest, [int | acc])
  end
end

defmodule Impl do
  def build_ordered(ints, rules) do
    Enum.reduce(ints, [], &insert(&1, &2, rules))
  end

  defp insert(int, [], _rules), do: [int]

  defp insert(int, [right | acc], rules) do
    if int in Map.get(rules, right, []) do
      [right | insert(int, acc, rules)]
    else
      [int, right | acc]
    end
  end

  def middle(ints), do: Enum.at(ints, div(length(ints), 2))
end

[unparsed_rules, unparsed_updates] = "day5_input" |> File.read!() |> String.split("\n\n")

rules =
  unparsed_rules
  |> String.split("\n", trim: true)
  |> Parser.page_ordering_rules()

{p1, p2} =
  unparsed_updates
  |> String.split("\n", trim: true)
  |> Enum.reduce({0, 0}, fn update, {p1, p2} ->
    ints = Parser.int_list(update)
    ordered = Impl.build_ordered(ints, rules)

    if ordered == ints do
      {p1 + Impl.middle(ints), p2}
    else
      {p1, p2 + Impl.middle(ordered)}
    end
  end)

IO.puts(p1)
IO.puts(p2)
