defmodule JViewer.Handler do
  @type super_data :: map()
  @type params :: any()

  @callback call(super_data(), params()) :: any()

  def put_handler(%JViewer.Types.Object{fields: fields} = return_schema, path, handler)
      when is_list(fields) and is_list(path) do
    put_key_value(return_schema, path, :handler, handler)
  end

  def put_params(%JViewer.Types.Object{fields: fields} = return_schema, path, params)
      when is_list(fields) and is_list(path) do
    put_key_value(return_schema, path, :handler_params, params)
  end

  defp put_key_value(%JViewer.Types.Object{fields: fields} = return_schema, path, key, value)
       when is_list(fields) and is_list(path) do
    case Enum.find(fields, fn f -> f.key == List.first(path) end) do
      nil ->
        raise JViewer.FieldException, {:field_not_found, List.first(path)}

      field ->
        update_object_fields(return_schema, field, path, key, value)
    end
  end

  defp put_key_value(%JViewer.Types.Array{type: type} = schema, path, key, value) do
    Map.put(schema, :type, put_key_value(type, path, key, value))
  end

  defp put_key_value(%JViewer.Types.Object.Field{} = field, path, key, value) do
    if length(path) == 1 do
      Map.put(field, key, value)
    else
      Map.put(field, :type, put_key_value(field.type, tl(path), key, value))
    end
  end

  defp put_key_value(_, path, _, _) do
    raise JViewer.FieldException, {:path_can_not_be_finished, path}
  end

  defp update_object_fields(
         %JViewer.Types.Object{fields: fields} = return_schema,
         field,
         path,
         key,
         value
       ) do
    fields =
      Enum.map(fields, fn f ->
        if f.key == field.key do
          try do
            put_key_value(field, path, key, value)
          rescue
            e in JViewer.FieldException ->
              JViewer.FieldException.add_to_path(e, List.first(path))
          end
        else
          f
        end
      end)

    Map.put(return_schema, :fields, fields)
  end
end
