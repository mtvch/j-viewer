defmodule JViewer.Test do
  use ExUnit.Case

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
                       handler: JViewer.CurrencyCodeHandler
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

  @data_sample %{
    coupon: nil,
    coupon_id: nil,
    currency: %{
      char: "د.إ",
      code: "AED",
      html_code: "&#1583;&#46;&#1573;",
      icon: nil,
      id: 174,
      inserted_at: ~N[2021-08-04 04:24:05],
      pp_country_set_id: nil,
      updated_at: ~N[2021-08-04 04:24:05]
    },
    currency_id: 174,
    id: 2,
    inserted_at: ~N[2021-08-04 04:24:06],
    items: [
      %{
        cart_id: 2,
        coupon_discount: 0,
        currency_code: "AED",
        id: 2,
        inserted_at: ~N[2021-08-04 04:24:06],
        optional_products: [
          %{
            cart_id: 2,
            coupon_discount: 0,
            currency_code: "AED",
            id: 3,
            inserted_at: ~N[2021-08-04 04:24:06],
            part_of_item_id: 2,
            product: %{
              url: "/product/another correct slug",
              is_new: false,
              description: "",
              avatar_id: nil,
              price_currency_char: nil,
              product_status: "on_sale",
              category: nil,
              updated_at: ~N[2021-08-04 04:24:06],
              id: 4,
              category_id: nil,
              short_description: "",
              prices: [],
              inserted_at: ~N[2021-08-04 04:24:06],
              translations: [
                %{
                  description: nil,
                  id: 4,
                  language: "en",
                  product_id: 4,
                  short_description: nil,
                  title: nil
                },
                %{
                  description: nil,
                  id: 5,
                  language: "fr",
                  product_id: 4,
                  short_description: nil,
                  title: nil
                },
                %{
                  description: nil,
                  id: 6,
                  language: "ru",
                  product_id: 4,
                  short_description: nil,
                  title: nil
                }
              ],
              integration_code: nil,
              title: "",
              parent_bundle_ids: nil
            },
            product_id: 4,
            quantity: 1,
            sum: 50,
            type: "optional",
            updated_at: ~N[2021-08-04 04:24:06]
          }
        ],
        part_of_item_id: nil,
        product: %{
          url: "/product/correct slug",
          is_new: false,
          description: "",
          avatar_id: nil,
          price_currency_char: nil,
          product_status: "on_sale",
          category: nil,
          updated_at: ~N[2021-08-04 04:24:06],
          id: 3,
          category_id: nil,
          short_description: "",
          prices: [],
          inserted_at: ~N[2021-08-04 04:24:06],
          translations: [
            %{
              description: nil,
              id: 7,
              language: "en",
              product_id: 3,
              short_description: nil,
              title: "Random product"
            },
            %{
              description: nil,
              id: 8,
              language: "fr",
              product_id: 3,
              short_description: nil,
              title: "Случайный товар по французски"
            },
            %{
              description: nil,
              id: 9,
              language: "ru",
              product_id: 3,
              short_description: nil,
              title: "Случайный товар"
            }
          ],
          integration_code: nil,
          title: "",
          parent_bundle_ids: nil,
          slug: "correct slug",
          bundle_children_ids: nil,
          is_bundle: false,
          price: nil,
          properties: [],
          basic_price: nil
        },
        product_id: 3,
        quantity: 5,
        sum: 500,
        type: "main",
        updated_at: ~N[2021-08-04 04:24:06]
      }
    ],
    session_id: 2,
    sum: 550,
    updated_at: ~N[2021-08-04 04:24:06],
    user: nil,
    user_id: nil
  }

  test "Parses data to json encodable" do
    return_schema =
      JViewer.Handler.put_params(@return_schema, ["items", "product", "title"], %{
        key: :title,
        lang: "en"
      })

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
      } = represent(@data_sample, return_schema)
  end
end
