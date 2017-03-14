defmodule Ebayka.GatewayTest do
  alias Ebayka.Gateway
  use ExUnit.Case, async: false
  import Mock

  @tuple_body {:Item, nil, [ {:Title, nil, "Ebay Product Title"} ] }

  def trim_xml(string), do: string |> String.replace(~r/\r|\n|\t|\s/, "")

  test "#make_request" do
    with_mock HTTPoison, [post: fn(_method, _body, _headers, _options) -> "<response></response>" end] do
      assert Gateway.make_request("AddItem", @tuple_body)
    end
  end

  test "#prepare_request when body is tuple" do
    assert(Gateway.prepare_request("AddItem", @tuple_body) |> trim_xml ==
      "<?xml version=\"1.0\" encoding=\"utf-8\"?>
      <AddItemRequest xmlns=\"urn:ebay:apis:eBLBaseComponents\">
        <RequesterCredentials>
          <eBayAuthToken>ebay_auth_token</eBayAuthToken>
        </RequesterCredentials>
        <Item>
          <Title>Ebay Product Title</Title>
        </Item>
      </AddItemRequest>" |> trim_xml
    )
  end
end
