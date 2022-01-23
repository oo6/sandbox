defmodule Sandbox.Utils do
  @spec parse_nanoseconds(binary()) :: {nanoseconds :: integer(), rest :: binary()} | :error
  def parse_nanoseconds(binary) when is_binary(binary) do
    case parse_nanoseconds(binary, _acc = 0, _starting_power = 100_000_000) do
      :error -> :error
      {_, ^binary} -> :error
      {_nanoseconds, _rest} = result -> result
    end
  end

  defp parse_nanoseconds(<<digit, _rest::binary>>, _acc, _power = 0) when digit in ?0..?9 do
    :error
  end

  defp parse_nanoseconds(<<digit, rest::binary>>, acc, power) when digit in ?0..?9 do
    digit = digit - ?0
    parse_nanoseconds(rest, acc + digit * power, div(power, 10))
  end

  defp parse_nanoseconds(rest, acc, _power) do
    {acc, rest}
  end
end
