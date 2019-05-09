# PhoneVerification

The package allows you to verify phone number using simple API and one of the providers (currently only Authy is supported).

## Installation

The package can be installed by adding `phone_verification` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:jason, "~> 1.1"}, # or any other JSON library
    {:phone_verification, "~> 0.4.0"}
  ]
end
```
## Config

Add the following configurations to your config file
```elixir
config :phone_verification,
  provider: PhoneVerification.Provider.Authy,
  default: [locale: :en, code_length: 4, via: :sms]

config :phone_verification, PhoneVerification.Provider.Authy,
  json_codec: Jason,
  api_key: System.get_env("AUTHY_API_KEY"),
  mocks: %{}
```

## Usage

```elixir
> PhoneVerification.start(%{phone_number: %PhoneVerification.PhoneNumber{country_code: "380", subscriber_number: "000000000"}})
{:ok, %{message: "Text message sent to +380 00-000-0000."}}

> PhoneVerification.check(%{phone_number: %PhoneVerification.PhoneNumber{country_code: "380", subscriber_number: "000000000"}, verification_code: "1111"})
{:ok, %{message: "Verification code is correct."}}

> PhoneVerification.check(%{phone_number: %PhoneVerification.PhoneNumber{country_code: "380", subscriber_number: "000000000"}, verification_code: "1111"})
{:error,
 %{
   code: "60023",
   message: "No pending verifications for +380 00-000-0000 found."
 }}

> %PhoneVerification.PhoneNumber{country_code: "380", subscriber_number: "000000000"} |> to_string()
"+380000000000"

```
Docs: [https://hexdocs.pm/phone_verification](https://hexdocs.pm/phone_verification).
