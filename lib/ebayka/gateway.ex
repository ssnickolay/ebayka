defmodule Ebayka.Gateway do
  import XmlBuilder
  use HTTPoison.Base

  @sandbox "https://api.sandbox.ebay.com/ws/api.dll"
  @production "https://api.ebay.com/ws/api.dll"

  def make_request(method, body) do
    post(url(), prepare_request(method, body), headers(method), options())
  end

  def prepare_request(method, body) do
    element("#{ method }Request", %{xmlns: "urn:ebay:apis:eBLBaseComponents"},
      [
        element(:RequesterCredentials, nil, [
          element(:eBayAuthToken, nil, config()[:auth_token])
        ])
      ] ++ [ body ]
    )
    |> generate
    |> add_xml_title
  end

  defp add_xml_title(xml), do: ~s(<?xml version="1.0" encoding="utf-8"?>#{ xml })

  defp headers(method) do
    %{
      "Content-type" => "application/xml",
      "X-EBAY-API-CALL-NAME" => method,
      "X-EBAY-API-COMPATIBILITY-LEVEL" => config()[:level],
      "X-EBAY-API-SITEID" => config()[:site_id],
      "X-EBAY-API-APP-NAME" => config()[:app_id],
      "X-EBAY-API-DEV-NAME" => config()[:dev_id],
      "X-EBAY-API-CERT-NAME" => config()[:cert_id]
    }
  end

  defp options do
    [
      connect_timeout: config()[:connect_timeout] || 100_000,
      recv_timeout: config()[:recv_timeout] || 100_000
    ]
  end

  defp url do
    if config()[:sandbox] do
      @sandbox
    else
      @production
    end
  end

  defp config, do: Application.get_env(:ebayka, Ebayka)
end
