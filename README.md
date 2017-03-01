Ebayka is a small library which makes it a little easier to use the eBay Trading API with Elixir.

## Getting Started

1. Add this to the `defp deps do` list in your mix.exs file:

  ```elixir
  {:ebayka, "~> 0.1"}
  ```

2. Also in mix.exs, add `:ebayka` and `:xml_builder` (for creating XML requests) to the `:applications` list in `def application`.
3. In config/dev.exs, configure `ebayka`:

   ```elixir
   config :ebayka, Ebayka,
     sandbox: true,
     app_id: "your Ebay app ID",
     dev_id: "your Ebay dev ID",
     cert_id: "your Ebay cert ID",
     auth_token: "your Ebay auth token",
     site_id: 0, # Your site id, 0 - USA
     level: 989, # API version
     gateway: Ebayka.Gateway # gateway for execute requests. By default: Ebayka.Gateway
   ```

4. Prepare Ebay request (full example you can see in [/examples](/examples) directory):

  ```elixir
  defmodule ReviseItemRequest do
    import XmlBuilder

    defp build(product) do
        [
          element(:Title, product.title),
          element(:Description, product.description),
          element(:PrimaryCategory, [ element(:CategoryID, product.category_id) ]),
          element(:StartPrice, product.price),
          ...
          element(:Site, "US")
        ]
    end
  end
  ```

5. Make the request:

  ```elixir
    Ebayka.Request.make("VerifyAddItem", ReviseItemRequest.build(product))
    # .. XML RESPONSE ..
  ```

Check out [/examples](/examples) directory as a quick intro.

## Contributing
If you feel like porting or fixing something, please drop a [pull request](https://github.com/GaussGroup/ebayka/pulls) or [issue tracker](https://github.com/GaussGroup/ebayka/issues) at GitHub! Check out the [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

## License
`Ebayka` source code is released under Apache 2 License.
Check [LICENSE](LICENSE) and [NOTICE](NOTICE) files for more details. The project HEAD is https://github.com/GaussGroup/ebayka.
