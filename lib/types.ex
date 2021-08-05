defmodule JViewer.Types do
  @moduledoc """
  Defines a single callback _apply_schema_.

  First argument of _apply_schema_ must be a struct (schema or part of schema) that implements given behaviour.
  Second argumet is data schema applying to.
  """
  @callback apply_schema(struct(), any()) :: any()
end
