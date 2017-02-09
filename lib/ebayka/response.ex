defmodule Ebayka.Response do
  import SweetXml

  @schema [
    ack: ~x"//*//Ack/text()"s,
    errors: ~x"//*//Errors//ShortMessage/text()"ls,
    code: ~x"//*//Errors//ErrorCode/text()"s,
  ]

  def build(body) do
    body
      |> xmap(@schema)
      |> Map.merge(%{ body: body })
  end
end
