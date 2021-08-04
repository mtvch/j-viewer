defmodule JViewer.Types.Array do
  defstruct [
    :type
  ]

  @behaviour JViewer.Types

  @type t :: %{
          __struct__: atom(),
          type: struct()
        }

  @impl true
  def apply_schema(%__MODULE__{type: %{__struct__: type_module} = type}, data)
      when is_list(data) do
    Enum.map(data, fn data -> type_module.apply_schema(type, data) end)
  end
end
