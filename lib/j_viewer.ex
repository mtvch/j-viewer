defmodule JViewer do
  @moduledoc """
  JViewer is an excellent way to declaratively represent elixir data in a JSON encodable format.
  """

  alias JViewer.Types.Object

  @type schema() :: JViewer.Types.Object.t()

  @spec represent(map, schema(), any()) :: map()
  @doc """
  Represents __data__ in a JSON encodable format according to __schema__.

  If __data__ cannot be represented, an exception is thrown.

  ## Example
      iex> import JViewer
      ...>
      iex> schema =
      iex>   object(
      iex>     fields: [
      iex>       field(
      iex>         key: "id",
      iex>         type: number()
      iex>       ),
      iex>       field(
      iex>         key: "title",
      iex>         type: string()
      iex>       )
      iex>     ]
      iex>   )
      ...>
      iex> data = %{
      iex>   id: 1,
      iex>   info: "I ate bread for breakfast",
      iex>   title: "Notes"
      iex> }
      ...>
      iex> represent(data, schema)
      %{
        "id" => 1,
        "title" => "Notes"
      }
  """
  def represent(data, schema, general_handlers_params \\ %{})

  def represent(%{} = data, %JViewer.Types.Object{} = schema, general_handlers_params) do
    Object.apply_schema(schema, data, general_handlers_params)
  end

  # Functions for building return schemas.

  @spec object(keyword()) :: struct()
  def object(args) do
    build_struct(%JViewer.Types.Object{}, args)
  end

  @spec field(keyword()) :: struct()
  def field(args) do
    build_struct(%JViewer.Types.Object.Field{}, args)
  end

  @spec number(keyword()) :: struct()
  def number(args \\ []) do
    build_struct(%JViewer.Types.Number{}, args)
  end

  @spec boolean(keyword()) :: struct()
  def boolean(args \\ []) do
    build_struct(%JViewer.Types.Boolean{}, args)
  end

  @spec array(keyword()) :: struct()
  def array(args) do
    build_struct(%JViewer.Types.Array{}, args)
  end

  @spec string(keyword()) :: struct()
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
