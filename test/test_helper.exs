defmodule JViewer.TestHelper do
  def get_data do
    %{
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
      title: ""
    }
  end

  def get_huge_data do
    %{
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
  end

  def title_handler(%{translations: translations}, %{key: key, lang: lang}) do
    case Enum.find(translations, fn t -> t.language == lang end) do
      nil ->
        ""

      translation ->
        Map.get(translation, key, "")
    end
  end

  def currency_code_handler(%{currency: %{code: code}}, _) do
    code
  end
end

ExUnit.start()
