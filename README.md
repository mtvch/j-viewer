# JViewer

JViewer is an excellent way to declaratively represent Elixir data in a JSON encodable format.

## Declarative
Explicitly describe what you want your data to look like in a __schema__.
```elixir
defmodule MyApp.DataPresenter do
  import JViewer

  @return_schema object(
    fields: [
      field(
        key: "id",
        type: number()
      ),
      field(
        key: "nested_data",
        source_key: "data",
        type: object(
          fields: [
            ...
          ]
        ),
        ...
      )
    ]
  )
end
```

## Flexible
Add dynamic processing using __handlers__.
```elixir
defmodule MyApp.DataPresenter do
  ...

  def present_for_client(data, params) do
    schema =
      @return_schema
      |> put_handler(["nested_data", "another_nested_data"], &MyApp.DataProcessor.process/2)
      |> put_handler_params(["nested_data", "another_nested_data"], params)

    represent(data, schema)
  end
end
```

## What should I write here?
Get nicely looking data ready to be encoded in JSON!
```elixir
%{
  "id" => 1,
  "nested_data" => %{
    ...
  }
}
```

## Installation

The package can be installed by adding `j_viewer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:j_viewer, "~> 0.1.2"}
  ]
end
```

## Documentation
[https://hexdocs.pm/j_viewer](https://hexdocs.pm/j_viewer)

## P.S.
JViewer's approach and implementation is inspired by an amazing params type validation library [Talos](https://github.com/balance-platform/talos).


