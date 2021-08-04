defmodule JViewer.Types.Number do
  defstruct []

  @behaviour JViewer.Types

  @type t :: %{
          __struct__: atom()
        }

  @impl true
  def apply_schema(%__MODULE__{}, data) when is_number(data) do
    data
  end
end
