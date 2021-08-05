defmodule JViewer.Test do
  use ExUnit.Case, async: true
  doctest JViewer

  import JViewer

  @huge_schema object(
                 fields: [
                   field(
                     key: "id",
                     type: number()
                   ),
                   field(
                     key: "currency_code",
                     source_key: "currency",
                     handler: true
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
                                         handler: true
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

  test "Parses huge data to nice and json encodable" do
    huge_data = JViewer.TestHelper.get_huge_data()

    schema =
      @huge_schema
      |> put_handler(["currency_code"], &JViewer.TestHelper.currency_code_handler/2)
      |> put_handler(["items", "product", "title"], &JViewer.TestHelper.title_handler/2)
      |> put_handler_params(["items", "product", "title"], %{key: :title, lang: "en"})

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
    } = represent(huge_data, schema)
  end
end
