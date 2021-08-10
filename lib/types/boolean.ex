defmodule JViewer.Types.Boolean do
  defstruct []

  @behaviour JViewer.Types

  @type t :: %{
          __struct__: atom()
        }

  @impl true
  def apply_schema(%__MODULE__{}, data, _) when is_boolean(data) do
    data
  end
end
