defmodule PhoneVerification.Provider do
  @callback start(%{
              required(:phone_number) => PhoneVerification.PhoneNumber.t(),
              required(:via) => :sms | :call,
              optional(:locale) => String.t(),
              optional(:code_length) => non_neg_integer(),
              optional(:custom_code) => PhoneVerification.verification_code()
            }) ::
              {:ok,
               %{
                 message: String.t(),
                 carrier: String.t(),
                 seconds_to_expire: non_neg_integer()
               }}
              | {:error, %{message: String.t(), code: non_neg_integer()}}

  @callback check(%{
              required(:phone_number) => PhoneVerification.PhoneNumber.t(),
              required(:verification_code) => PhoneVerification.verification_code()
            }) ::
              {:ok, %{message: String.t()}} | {:error, %{message: String.t(), code: String.t()}}
end
