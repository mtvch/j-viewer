defmodule JViewer.Types do
  @moduledoc """
  Defines a single callback _apply_schema_.

  First argument of _apply_schema_ must be a struct that implements given behaviour.
  """
  @callback apply_schema(struct(), any()) :: any()
end
