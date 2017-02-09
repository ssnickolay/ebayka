defmodule Ebayka.StubGateway do
  def make_request("AddItem", {:Item, nil, [ {:Title, nil, "Invalid Product"} ] }) do
    {:ok,
      %HTTPoison.Response{
        status_code: 200,
        body: "<?xml version=\"1.0\" encoding=\"utf-8\"?>
               <AddItemResponse xmlns=\"urn:ebay:apis:eBLBaseComponents\">
                 <Ack>Failure</Ack>
                 <Errors>
                   <ShortMessage>This Listing is a duplicate of your item: New product 2 (110185886058).</ShortMessage>
                 </Errors>
               </AddItemResponse>"
      }
    }
  end

  def make_request("AddItem", {:Item, nil, [ {:Title, nil, "Ebay Product Title"} ] }) do
    {:ok,
      %HTTPoison.Response{
        status_code: 200,
        body: "<?xml version=\"1.0\" encoding=\"utf-8\"?>
              <AddItemResponse xmlns=\"urn:ebay:apis:eBLBaseComponents\">
                <Ack>Success</Ack>
                <ItemID>110185886058</ItemID>
              </AddItemResponse>"
      }
    }
  end

  def make_request("VerifyAddItem", _body) do
    {:ok,
      %HTTPoison.Response{
        status_code: 200,
        body: "<?xml version=\"1.0\" encoding=\"utf-8\"?>
              <VerifyAddItemResponse xmlns=\"urn:ebay:apis:eBLBaseComponents\">
                <Ack>Success</Ack>
              </VerifyAddItemResponse>"
      }
    }
  end
end
