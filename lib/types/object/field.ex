defmodule JViewer.Types.Object.Field do
  defstruct [
    :key,
    :source_key,
    :type,
    :description,
    :handler,
    handler_params: %{},
    allow_null: false
  ]

  @behaviour JViewer.Types

  @type t :: %{
          __struct__: atom(),
          key: String.t(),
          source_key: String.t() | atom() | nil,
          type: struct(),
          description: String.t() | nil,
          handler: function() | boolean() | nil,
          handler_params: any(),
          allow_null: boolean()
        }

  @impl true
  def apply_schema(%__MODULE__{handler: handler, handler_params: params}, super_data)
      when is_function(handler, 2) do
    handler.(super_data, params)
  end

  @impl true
  def apply_schema(%__MODULE__{handler: true, key: key}, _super_data) do
    raise JViewer.FieldException, {:handler_not_found, key}
  end

  @impl true
  def apply_schema(
        %__MODULE__{type: %{__struct__: _}, key: key, source_key: source_key} = schema,
        super_data
      )
      when is_binary(key) and not is_nil(source_key) do
    apply_to_data(schema, Map.get(super_data, source_key, %JViewer.FieldException{}))
  end

  @impl true
  def apply_schema(%__MODULE__{type: %{__struct__: _}, key: key} = schema, super_data)
      when is_binary(key) do
    apply_to_data(
      schema,
      super_data,
      Map.get(super_data, String.to_atom(key), %JViewer.FieldException{})
    )
  end

  defp apply_to_data(%__MODULE__{key: key} = schema, super_data, %JViewer.FieldException{}) do
    apply_to_data(schema, Map.get(super_data, key, %JViewer.FieldException{}))
  end

  defp apply_to_data(%__MODULE__{allow_null: false, key: key}, _, nil) do
    raise JViewer.FieldException, {:data_is_null, key}
  end

  defp apply_to_data(%__MODULE__{} = schema, _, data) do
    apply_to_data(schema, data)
  end

  defp apply_to_data(%__MODULE__{allow_null: true}, nil) do
    nil
  end

  defp apply_to_data(%__MODULE__{key: key}, nil) do
    raise JViewer.FieldException, {:data_is_null, key}
  end

  defp apply_to_data(%__MODULE__{key: key}, %JViewer.FieldException{}) do
    raise JViewer.FieldException, {:field_not_found, key}
  end

  defp apply_to_data(%__MODULE__{type: %{__struct__: type_module} = type, key: key}, data) do
    try do
      type_module.apply_schema(type, data)
    rescue
      e in JViewer.FieldException ->
        raise JViewer.FieldException.add_to_path(e, key)
    end
  end
end
