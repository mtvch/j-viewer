ExUnit.start()

defmodule JViewer.CurrencyCodeHandler do
  @behaviour JViewer.Handler

  def call(%{currency: %{code: code}}, _) do
    code
  end
end
