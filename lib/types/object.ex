defmodule JViewer.Types.Object do
  defstruct [
    :fields
  ]

  @behaviour JViewer.Types

  @type t :: %{
          __struct__: atom(),
          fields: list(Field.t()) | nil
        }

  alias JViewer.Types.Object.Field

  @impl true
  def apply_schema(%__MODULE__{fields: fields}, %{} = data, general_handlers_params)
      when is_list(fields) do
    reduce_f = fn field, acc ->
      Map.put(
        acc,
        field.key,
        Field.apply_schema(field, data, general_handlers_params)
      )
    end

    Enum.reduce(fields, %{}, reduce_f)
  end
end
