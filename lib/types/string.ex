defmodule JViewer.Types.String do
  defstruct []

  @behaviour JViewer.Types

  @type t :: %{
          __struct__: atom()
        }

  @impl true
  def apply_schema(%__MODULE__{}, data) when is_binary(data) do
    data
  end

  def apply_schema(%__MODULE__{}, data) do
    to_string(data)
  end
end
