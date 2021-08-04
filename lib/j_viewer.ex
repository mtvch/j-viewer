defmodule JViewer do
  @moduledoc """
  JViewer is an excellent way to declaratively represent elixir data in json encodable format.
  """

  def represent(%{} = data, %JViewer.Types.Object{} = return_schema) do
    JViewer.Types.Object.apply_schema(return_schema, data)
  end

  def object(args) do
    build_struct(%JViewer.Types.Object{}, args)
  end

  def field(args) do
    build_struct(%JViewer.Types.Object.Field{}, args)
  end

  def number(args \\ []) do
    build_struct(%JViewer.Types.Number{}, args)
  end

  def boolean(args \\ []) do
    build_struct(%JViewer.Types.Boolean{}, args)
  end

  def array(args) do
    build_struct(%JViewer.Types.Array{}, args)
  end

  def string(args \\ []) do
    build_struct(%JViewer.Types.String{}, args)
  end

  defp build_struct(type, args) do
    if !Keyword.keyword?(args), do: raise(ArgumentError)

    type
    |> Map.keys()
    |> Enum.reduce(type, fn key, res ->
      value =
        case Keyword.get(args, key) do
          nil -> Map.get(type, key)
          v -> v
        end

      Map.put(res, key, value)
    end)
  end
end
