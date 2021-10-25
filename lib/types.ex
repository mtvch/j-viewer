defmodule JViewer.Types do
  @moduledoc """
  JViewer.Types behaviour.

  Defines a single callback `apply_schema`.

  First argument of `apply_schema` must be a `schema` of a module that implements given behaviour.
  Second argumet is `data` schema applying to.
  Third argument is `general handler params`, which can be ignored by types that are not nested
  """
  @callback apply_schema(struct(), any(), any()) :: any()
end
