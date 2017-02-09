defmodule Ebayka.RequestTest do
  alias Ebayka.Request
  use ExUnit.Case, async: false

  @request {:Item, nil, [ {:Title, nil, "Ebay Product Title"} ] }
  @invalid_request {:Item, nil, [ {:Title, nil, "Invalid Product"} ] }

  defmodule AddItemResponseTest do
    import SweetXml

    @schema [
      ack: ~x"//AddItemResponse//Ack/text()"s,
      id: ~x"//AddItemResponse//ItemID/text()"s,
      errors: ~x"//AddItemResponse//Errors//ShortMessage/text()"ls,
    ]

    def build(body) do
      body |> xmap(@schema)
    end
  end

  test "#make when name is nil" do
    assert_raise Ebayka.RequestError, "You should set name of Ebay method", fn ->
      Request.make(nil, @request)
    end
  end

  test "#make when body is nil" do
    assert_raise Ebayka.RequestError, "You should set body of Ebay method", fn ->
      Request.make("AddItem", nil)
    end
  end

  test "#make" do
    assert {:ok, %HTTPoison.Response{ status_code: 200, body: _body }} = Request.make("AddItem", @request)
  end

  test "#make with handle response (invalid request parse with default mapper)" do
    { :ok, response } = Request.make_and_parse("AddItem", @invalid_request)

    assert %{ errors: ["This Listing is a duplicate of your item: New product 2 (110185886058)."], ack: "Failure", code: "", body: _body} = response
  end

  test "#make with handle response (valid request)" do
    { :ok, response } = Request.make_and_parse("AddItem", @request, AddItemResponseTest)

    assert response.ack == "Success"
    assert response.id == "110185886058"
    assert response.errors == []
  end
end
