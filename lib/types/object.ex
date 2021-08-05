defmodule JViewer.Types.Object do
  defstruct [
    :fields
  ]

  @behaviour JViewer.Types

  @type t :: %{
          __struct__: atom(),
          fields: list(Field.t()) | nil
        }

  alias JViewer.Types

  @impl true
  def apply_schema(%__MODULE__{fields: fields}, %{} = data) when is_list(fields) do
    reduce_f = fn field, acc ->
      Map.put(acc, field.key, Types.Object.Field.apply_schema(field, data))
    end

    Enum.reduce(fields, %{}, reduce_f)
  end

  def put(%JViewer.Types.Object{fields: fields} = schema, path, key, value)
      when is_list(fields) and is_list(path) do
    case Enum.find(fields, fn f -> f.key == List.first(path) end) do
      nil ->
        raise JViewer.FieldException, {:field_not_found, List.first(path)}

      field ->
        update_object_fields(schema, field, path, key, value)
    end
  end

  def put(%JViewer.Types.Array{type: type} = schema, path, key, value) do
    Map.put(schema, :type, put(type, path, key, value))
  end

  def put(%JViewer.Types.Object.Field{} = field, path, key, value) do
    if length(path) == 1 do
      Map.put(field, key, value)
    else
      Map.put(field, :type, put(field.type, tl(path), key, value))
    end
  end

  def put(_, path, _, _) do
    raise JViewer.FieldException, {:path_can_not_be_finished, path}
  end

  defp update_object_fields(
         %JViewer.Types.Object{fields: fields} = schema,
         field,
         path,
         key,
         value
       ) do
    fields =
      Enum.map(fields, fn f ->
        if f.key == field.key do
          try do
            put(field, path, key, value)
          rescue
            e in JViewer.FieldException ->
              JViewer.FieldException.add_to_path(e, List.first(path))
          end
        else
          f
        end
      end)

    Map.put(schema, :fields, fields)
  end
end
