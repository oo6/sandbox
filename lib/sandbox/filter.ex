defmodule Sandbox.Filter do
  @callback filter_by_attr(
              {attribute :: String.t(), value :: String.t()},
              query :: Ecto.Query.t()
            ) :: Ecto.Query.t()

  def apply(query, nil, _), do: query

  def apply(query, filter, module) do
    filter
    |> Enum.reject(&(elem(&1, 1) == ""))
    |> Enum.reduce(query, &module.filter_by_attr/2)
  end
end
