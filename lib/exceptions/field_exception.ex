defmodule JViewer.FieldException do
  defexception [
    :message,
    :code,
    path: []
  ]

  @impl true
  def exception({code, path}) when not is_list(path) do
    exception({code, [path]})
  end

  def exception({code, path}) do
    msg = "#{code}. Path: #{inspect(path)}"
    %JViewer.FieldException{message: msg, code: code, path: path}
  end

  def add_to_path(%JViewer.FieldException{code: code, path: old_path}, step) do
    path = [step] ++ old_path
    msg = "#{code}. Path: #{inspect(path)}"
    %JViewer.FieldException{path: path, message: msg}
  end
end
