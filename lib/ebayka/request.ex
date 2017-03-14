defmodule Ebayka.Request do
  def make(nil, _body), do: raise(Ebayka.RequestError, message: "You should set name of Ebay method")
  def make(_name, nil), do: raise(Ebayka.RequestError, message: "You should set body of Ebay method")
  def make(name, body), do: gateway().make_request(name, body)

  def make_and_parse(name, body, mapper \\ Ebayka.Response), do: make(name, body) |> handle_make(mapper)

  defp handle_make({:ok, %HTTPoison.Response{status_code: 200, body: body}}, mapper) do
    { :ok, mapper.build(body) }
  end
  defp handle_make(_, _), do: { :error, nil }

  defp gateway, do: config()[:gateway] || Ebayka.Gateway
  defp config, do: Application.get_env(:ebayka, Ebayka)
end
