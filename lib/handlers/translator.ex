defmodule JViewer.Handlers.Translator do
  @moduledoc """
  JViewer translations handler
  """
  @behaviour JViewer.Handler

  @doc """
  Translates value under __key__ according to __translations__, where __translations__
  is a list of structs that look like

  ```elixir
  %{
    language: code # string like "en"
    key: translation # translation for a given key
  }

  Return an empty string if no translation is found.
  """
  def call(%{translations: translations}, %{key: key, lang: lang}) do
    case Enum.find(translations, fn t -> t.language == lang end) do
      nil ->
        ""

      translation ->
        Map.get(translation, key, "")
    end
  end
end
