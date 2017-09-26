defmodule EbayProduct do
  defstruct :
end

defmodule AddItemRequest do
  import XmlBuilder

  defp attributes(product) do
    element(:Item, [
      element(:Title, product.title),
      element(:SubTitle, product.sub_title),
      element(:Description, product.desciprion),
      element(:HitCounter, 5),
      element(:PrimaryCategory, [ element(:CategoryID, product.category_id) ]),
      element(:StartPrice, product.price),
      element(:CategoryMappingAllowed, true),
      element(:ConditionID, 1000), # 1000 - New with Tags
      element(:Country, "US"),
      element(:Currency, "USD"),
      element(:DispatchTimeMax, Application.get_env(:inventory_core, :ebay_api)[:dispatch_time_max]),
      element(:ListingDuration, Application.get_env(:inventory_core, :ebay_api)[:listing_duration]),
      element(:Location, Application.get_env(:inventory_core, :ebay_api)[:location]),
      element(:ListingType, "FixedPriceItem"),
      element(:PayPalEmailAddress, Application.get_env(:inventory_core, :ebay_api)[:pay_pal_email]),
      element(:PostalCode, Application.get_env(:inventory_core, :ebay_api)[:postal_code]),
      element(:Quantity, 1), # Only by one item
      element(:SKU, product.sku),
      element(:ItemSpecifics, specifics(product.ebay_product)),
      element(:BuyerRequirementDetails, [
        element(:ShipToRegistrationCountry, true)
      ]),
      element(:ReturnPolicy, [
        element(:ReturnsAcceptedOption, "ReturnsAccepted"),
        element(:RefundOption, "MoneyBack"),
        element(:ReturnsWithinOption, Application.get_env(:inventory_core, :ebay_api)[:returns_within_option]),
        element(:Description, Application.get_env(:inventory_core, :ebay_api)[:return_description]),
        element(:ShippingCostPaidByOption, "Buyer")
      ]),
      element(:ShipToLocations, Application.get_env(:inventory_core, :ebay_api)[:ship_to_locations]),
      element(:ShippingDetails, [
        element(:ShippingType, "Flat"),
        element(:ShippingServiceOptions, [
          element(:ShippingServicePriority, 1),
          element(:ShippingService, "USPSMedia"),
          element(:ShippingServiceCost, 2.50),
          element(:ShippingServiceAdditionalCost, 2.50)
        ]),
      ]),
      element(:Site, "US")
    ])
  end
end


defmodule ProductRepository do
  @success %{ack: "Success"}
  @warning %{ack: "Warning"}
  @fail %{ack: "Failure"}

  def verify(%EbayProduct{} = product) do
    "VerifyAddItem"
    |> Ebayka.Request.make_and_parse(AddItemRequest.build(product))
    |> handle_response
  end

  defp handle_response({:ok, @success}), do: { :ok, true }
  defp handle_response({:ok, @warning}), do: { :ok, true }
  defp handle_response({:ok, @fail = response}), do: { :error, response.errors }
  defp handle_response({:error, nil}), do: { :error, [ "Fatal exception" ] }
end
