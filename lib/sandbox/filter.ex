defmodule Sandbox.Filter do
  @callback filter_by(query :: Ecto.Query.t(), field :: atom(), value :: String.t()) ::
              Ecto.Query.t()

  import Ecto.Query

  def apply(query, nil), do: query

  def apply(query, filter) do
    Enum.reduce(filter, query, fn
      {field, operator, value}, acc when is_function(operator) ->
        Kernel.apply(operator, [acc, field, value])

      {field, operator, value}, acc ->
        filter_by(acc, field, operator, value)

      {assoc, field, operator, value}, acc when is_function(operator) ->
        Kernel.apply(operator, [left_join_once(acc, assoc), field, value])

      {assoc, field, operator, value}, acc ->
        assoc_filter_by(acc, assoc, field, operator, value)
    end)
  end

  defp filter_by(query, _field, _operator, value) when value in [nil, ""], do: query
  defp filter_by(query, field, :eq, value), do: where(query, [q], field(q, ^field) == ^value)
  defp filter_by(query, field, :lte, value), do: where(query, [q], field(q, ^field) <= ^value)
  defp filter_by(query, field, :gte, value), do: where(query, [q], field(q, ^field) >= ^value)
  defp filter_by(query, field, :in, value), do: where(query, [q], field(q, ^field) in ^value)

  defp assoc_filter_by(query, _assoc, _field, _operator, value) when value in [nil, ""], do: query

  defp assoc_filter_by(query, assoc, field, :eq, value) do
    query
    |> left_join_once(assoc)
    |> where([{^assoc, s}], field(s, ^field) == ^value)
  end

  defp left_join_once(query, assoc) do
    if has_named_binding?(query, assoc) do
      query
    else
      join(query, :left, [q], assoc(q, ^assoc), as: ^assoc)
    end
  end
end
