@doc """
Notice: ProductRepository and EbayProduct implemented in examples/product_repository.ex

## Setup config/text.exs
  config :ebayka, Ebayka,
    ...
    gateway: EbayStubGateway

## ExUnit examples
    iex> ebay_product = %EbayProduct{title: "Bad Product"}
    iex> assert {:error, ["The category selected is not a leaf category."]} = ProductRepository.verify(ebay_product)

    iex> ebay_product = %EbayProduct{title: "Warning product"}
    iex> assert {:ok, true} = ProductRepository.verify(ebay_product)

    iex> ebay_product = %EbayProduct{}
    iex> assert {:ok, true} = ProductRepository.verify(ebay_product)
"""
defmodule EbayStubGateway
  def make_request("VerifyAddItem", %{title: "Bad Product"}) do
      {:ok,
        %HTTPoison.Response{
          status_code: 200,
          body: ~s(<?xml version="1.0" encoding="utf-8"?>
                 <VerifyAddItemResponse xmlns="urn:ebay:apis:eBLBaseComponents">
                   <Ack>Failure</Ack>
                   <Errors>
                     <ShortMessage>The category selected is not a leaf category.</ShortMessage>
                   </Errors>
                   <Errors>
                     <ShortMessage>Please enter a valid price for your item \(e.g. $0.01\).</ShortMessage>
                   </Errors>
                 </VerifyAddItemResponse>)
        }
      }
    end

    def make_request("VerifyAddItem", %{title: "Warning product"}) do
      {:ok,
        %HTTPoison.Response{
          status_code: 200,
          body: ~s(<?xml version="1.0" encoding="utf-8"?>
                 <VerifyAddItemResponse xmlns="urn:ebay:apis:eBLBaseComponents">
                   <Ack>Warning</Ack>
                   <Errors>
                     <ShortMessage>Condition is not applicable for this category.</ShortMessage>
                   </Errors>
                 </VerifyAddItemResponse>)
        }
      }
    end

    def make_request("VerifyAddItem", _) do
      {:ok,
        %HTTPoison.Response{
          status_code: 200,
          body: ~s(<?xml version="1.0" encoding="utf-8"?>
                 <VerifyAddItemResponse xmlns="urn:ebay:apis:eBLBaseComponents">
                   <Ack>Success</Ack>
                 </VerifyAddItemResponse>)
        }
      }
    end
end
