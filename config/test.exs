use Mix.Config

config :ebayka, Ebayka,
  sandbox: true,
  app_id: "ebay_app_id",
  dev_id: "ebay_dev_id",
  cert_id: "ebay_cert_id",
  auth_token: "ebay_auth_token",
  site_id: 0,
  level: 989,
  gateway: Ebayka.StubGateway
