# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :phone_verification,
  provider: PhoneVerification.Provider.Authy,
  default: [locale: :en, code_length: 4, via: :sms]

config :phone_verification, PhoneVerification.Provider.Authy,
  # json_codec: Jason,
  api_key: System.get_env("AUTHY_API_KEY"),
  # example: %{ "+380001234567" => "0000", "+380001234568" => "1234" }
  mocks: %{}
