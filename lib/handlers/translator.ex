defmodule JViewer.Handlers.Translator do
  @behaviour JViewer.Handler
  def call(%{translations: translations}, %{key: key, lang: lang}) do
    case Enum.find(translations, fn t -> t.language == lang end) do
      nil ->
        nil

      translation ->
        Map.get(translation, key)
    end
  end
end
