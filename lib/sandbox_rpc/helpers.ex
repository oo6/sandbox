defmodule SandboxRPC.Helpers do
  defmacro render(stream, data) do
    quote bind_quoted: [stream: stream, data: data] do
      {name, _} = __ENV__.function
      camelized_name = name |> to_string() |> Macro.camelize() |> String.to_existing_atom()

      case Enum.find(
             __MODULE__.__meta__(:service).__rpc_calls__,
             &match?({^camelized_name, _, _}, &1)
           ) do
        {_, _, {type, true}} ->
          Enum.each(data, &GRPC.Server.send_reply(stream, type.new(&1)))
          stream

        {_, _, {type, false}} ->
          type.new(data)
      end
    end
  end

  # experimental, may be move into a common module.
  def capitalize_enum_values(struct_or_map) do
    # NOTE: Why not use %mod{} = struct?
    # Map.from_struct(struct) may have been called before.
    mod = struct_or_map.__meta__.schema

    mod.__schema__(:fields)
    |> Enum.map(&{&1, mod.__schema__(:type, &1)})
    |> Enum.filter(&match?({_, {:parameterized, Ecto.Enum, _}}, &1))
    |> Enum.reduce(struct_or_map, fn {field, _type}, acc ->
      # NOTE: capitalize_atom use String.to_atom/1, For security we can add include or except opts
      value = acc |> Map.fetch!(field) |> capitalize_atom()
      %{acc | field => value}
    end)
  end

  defp capitalize_atom(atom) do
    atom |> to_string() |> String.upcase() |> String.to_atom()
  end
end
