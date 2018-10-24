defmodule PhoneVerification.Provider do
  @type phone_number :: %{
          required(:country_code) => non_neg_integer() | String.t(),
          required(:subscriber_number) => String.t()
        }
  @type verification_code :: String.t()

  @callback start(%{
              required(:phone_number) => phone_number(),
              required(:via) => :sms | :call,
              optional(:locale) => String.t(),
              optional(:code_length) => non_neg_integer(),
              optional(:custom_code) => verification_code()
            }) ::
              {:ok, %{message: String.t()}} | {:error, %{message: String.t(), code: String.t()}}

  @callback check(%{
              required(:phone_number) => phone_number(),
              required(:verification_code) => verification_code()
            }) ::
              {:ok, %{message: String.t()}} | {:error, %{message: String.t(), code: String.t()}}
end
