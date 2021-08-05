# JViewer

JViewer is an excellent way to declaratively represent elixir data in a JSON encodable format.

## Installation

The package can be installed by adding `j_viewer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:j_viewer, "~> 0.1.1"}
  ]
end
```

## Introduction

 Imagine you have an application that stores data in a relational database.
  When your application grows large, data becomes to have many dependencis.

  For example, you are developing an online store, where you have a cart.
  You can apply coupons to your cart, your cart can consist of many items,
  which refer to many products
  which refer to many prices or translations, which refer to...

  Now you want to send a cart to a client.

  Usually you don't want to send this infinite chain of dependencies,
  not even all of the fields of the cart.

  You have to first:
  delete fields that are not even convertable,
  like meta data fields, then delete all extra fields that
  are not needed by client, then do some processing on some fields.
  And your processing depends on mysterious 'params' determined in a runtime.

  Coding all of this for each case, for each entity, becomes such a pain.
  And even more pain it is for a person who is trying to figure out,
  what this code is doing.

  With JViewer you just need to explicitly delcare WHAT you want your data to look like
  after processing, and it will do the job for you.

  ## Example
  Let's go back to the cart case.

  After fetching needed entry with all possibly needed assocs preloaded,
  you have something like this:

  ```elixir
  %{
    ...
    coupon_id: nil,
    currency: %{
      char: "د.إ",
      code: "AED",
      ...
      updated_at: ~N[2021-08-04 04:24:05]
    },
    currency_id: 174,
    id: 2,
    inserted_at: ~N[2021-08-04 04:24:06],
    items: [
      %{
        coupon_discount: 0,
        currency_code: "AED",
        id: 2,
        inserted_at: ~N[2021-08-04 04:24:06],
        part_of_item_id: nil,
        ...
        optional_products: [
          ...
        ],
        part_of_item_id: nil,
        product: %{
          url: "/product/correct slug",
          ...
          translations: [
            %{
              ...
              short_description: nil,
              title: "Random product"
            },
            ...
          ],
          title: "",
          ...
        },
       ...
      }
    ],
    ...
  }
  ```

  To get a look at the full data sample, see test/j_viewer_test.exs.

  On a client we need _coupon_id_, _id_, also we need to add _currency_code_ field
  with a value of a code of a currency. And we need some information about _items_ dependency:
  array of items, where each item is an object with fields
  _coupon_discount_, _inserted_at_ (for whatever reason), _part_of_item_id_, _product_.
  From our _product_ we need only a title, translated to the language of a user, that sent the request.

  To achieve all of that with JViewer, we just say what we want!

  ```elixir
  defmodule MyAppWeb.CartPresenter do
    import JViewer

    @return_schema object(
                   fields: [
                     field(
                       key: "id",
                       type: number()
                     ),
                     field(
                       key: "currency_code",
                       source_key: "currency",
                       # Your custom handler,
                       # For more info see Handlers docs
                       handler: MyAppWeb.CartView.CurrencyCodeHandler
                     ),
                     field(
                       key: "coupon_id",
                       type: number(),
                       allow_null: true
                     ),
                     field(
                       key: "items",
                       type:
                         array(
                           type:
                             object(
                               fields: [
                                 field(
                                   key: "coupon_discount",
                                   type: number()
                                 ),
                                 field(
                                   key: "inserted_at",
                                   type: string()
                                 ),
                                 field(
                                   key: "part_of_item_id",
                                   type: number(),
                                   allow_null: true
                                 ),
                                 field(
                                   key: "product",
                                   type:
                                     object(
                                       fields: [
                                         field(
                                           key: "title",
                                           type: string(),
                                           handler: JViewer.Handlers.Translator
                                         )
                                       ]
                                     )
                                 )
                               ]
                             )
                         )
                     )
                   ]
                 )

    def view(%MyApp.Cart{} = cart, %{lang: lang}) do
      return_schema =
        JViewer.Handler.put_params(@return_schema, ["items", "product", "title"], %{
          key: :title,
          lang: lang
        })

      represent(cart, return_schema)
    end
  end
  ```

  If let's say our user needs English, here is result:
  ```elixir
    %{
      "coupon_id" => nil,
      "currency_code" => "AED",
      "id" => 2,
      "items" => [
        %{
          "coupon_discount" => 0,
          "inserted_at" => "2021-08-04 04:24:06",
          "part_of_item_id" => nil,
          "product" => %{"title" => "Random product"}
        }
      ]
    }
  ```

## Documentation
For more information, see [https://hexdocs.pm/j_viewer]


