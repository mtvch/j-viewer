defmodule JViewer do
  @moduledoc """
  JViewer is an excellent way to declaratively represent elixir data in a JSON encodable format.
  """

  @type schema() :: JViewer.Types.Object.t()

  @spec represent(map, schema()) :: map()
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
  def represent(%{} = data, %JViewer.Types.Object{} = schema) do
    JViewer.Types.Object.apply_schema(schema, data)
  end

  @spec put_handler(schema(), list(), function()) :: schema
  @doc """
  Puts __handler__ in __schema's field__ under given __path__.

  If __path__ cannot be followed, an exception is thrown.

  ## Example
      iex> import JViewer
      ...>
      iex> schema =
      iex>    object(
      iex>      fields: [
      iex>        field(
      iex>          key: "product",
      iex>          type: object(
      iex>            fields: [
      iex>              field(
      iex>                key: "price",
      iex>              )
      iex>            ]
      iex>          )
      iex>        )
      iex>      ]
      iex>    )
      ...>
      iex> put_handler(schema, ["product", "price"], &Map.get/2)
      object(
        fields: [
          field(
            key: "product",
            type: object(
              fields: [
                field(
                  key: "price",
                  handler: &Map.get/2
                )
              ]
            )
          )
        ]
      )
  """
  def put_handler(%JViewer.Types.Object{fields: fields} = schema, path, handler)
      when is_list(fields) and is_list(path) and path != [] and is_function(handler, 2) do
    JViewer.Types.Object.put(schema, path, :handler, handler)
  end

  @spec put_handler_params(schema(), list(), any) :: schema()
  @doc """
  Puts __handler_params__ in __schema's field__ under given __path__.

  If __path__ cannot be followed, an exception is thrown.

  ## Example
      iex> import JViewer
      ...>
      iex> schema =
      iex>    object(
      iex>      fields: [
      iex>        field(
      iex>          key: "product",
      iex>          type: object(
      iex>            fields: [
      iex>              field(
      iex>                key: "price",
      iex>                handler: &Map.get/2
      iex>              )
      iex>            ]
      iex>          )
      iex>        )
      iex>      ]
      iex>    )
      ...>
      iex> put_handler_params(schema, ["product", "price"], :price)
      object(
        fields: [
          field(
            key: "product",
            type: object(
              fields: [
                field(
                  key: "price",
                  handler: &Map.get/2,
                  handler_params: :price
                )
              ]
            )
          )
        ]
      )
  """
  def put_handler_params(%JViewer.Types.Object{fields: fields} = schema, path, params)
      when is_list(fields) and is_list(path) and path != [] do
    JViewer.Types.Object.put(schema, path, :handler_params, params)
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
