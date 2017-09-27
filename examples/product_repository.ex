defmodule EbayProduct do
  @moduledoc """
  Simple struct for DSL
  """
  defstruct title: nil, description: nil, category_id: nil, price: nil, quantity: nil, sku: nil
end

defmodule VerifyAddItem do
  @moduledoc """
  VerifyAddItem request
  """
  import XmlBuilder

  def build(product) do
    element(:Item, [
      element(:Title, product.title),
      element(:Description, product.desciprion),
      element(:PrimaryCategory, [ element(:CategoryID, product.category_id) ]),
      element(:StartPrice, product.price),
      element(:CategoryMappingAllowed, true),
      element(:ConditionID, 1000), # 1000 - New with Tags
      element(:Country, "US"),
      element(:Currency, "USD"),
      element(:DispatchTimeMax, 3),
      element(:ListingDuration, "Days_7"),
      element(:Location, Application.get_env(:inventory_core, :ebay_api)[:location]),
      element(:ListingType, "FixedPriceItem"),
      element(:PayPalEmailAddress, "magicalbookseller@yahoo.com"),
      element(:PostalCode, 95125),
      element(:Quantity, product.quantity),
      element(:SKU, product.sku),
      element(:BuyerRequirementDetails, [
        element(:ShipToRegistrationCountry, true)
      ]),
      element(:ReturnPolicy, [
        element(:ReturnsAcceptedOption, "ReturnsAccepted"),
        element(:RefundOption, "MoneyBack"),
        element(:ReturnsWithinOption, "Days_30"),
        element(:Description, "If you are not satisfied, return the book for refund."),
        element(:ShippingCostPaidByOption, "Buyer")
      ]),
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

  @doc """
  ## Example
      iex> ebay_product = %EbayProduct{
        title: "Harry Potter and the Philosopher's Stone",
        description: "This is the first book in the Harry Potter series. In excellent condition!",
        category_id: 377,
        price: 1.0,
        quantity: 1,
        sku: "EA-123"
      }
      iex> case ProductRepository.verify(ebay_product) do
        {:ok, _} ->
          IO.puts("Ebay product is valid")
        {:error, errors} ->
          IO.puts("Errors: #{inspec errors}")
      end
  """

defmodule ProductRepository do
  @moduledoc """
  Layer between Entity and Ebayka DSL
  """
  @success %{ack: "Success"}
  @warning %{ack: "Warning"}
  @fail %{ack: "Failure"}

  def verify(%EbayProduct{} = product) do
    "VerifyAddItem"
    |> Ebayka.Request.make_and_parse(VerifyAddItem.build(product))
    |> handle_response
  end

  defp handle_response({:ok, @success}), do: {:ok, true}
  defp handle_response({:ok, @warning}), do: {:ok, true}
  defp handle_response({:ok, @fail = response}), do: {:error, response.errors}
  defp handle_response({:error, nil}), do: {:error, ["Fatal exception"]}
end
