defmodule PhoneVerification do
  @behaviour PhoneVerification.Provider

  @type verification_code :: String.t()

  def config(key) do
    Application.get_env(:phone_verification, key)
  end

  @spec start(%{
          required(:phone_number) => PhoneVerification.PhoneNumber.t(),
          required(:via) => :sms | :call,
          optional(:locale) => String.t(),
          optional(:code_length) => non_neg_integer(),
          optional(:custom_code) => PhoneVerification.verification_code()
        }) ::
          {:ok,
           %{
             message: String.t(),
             seconds_to_expire: non_neg_integer()
           }}
          | {:error, %{message: String.t(), code: non_neg_integer()}}
  def start(params) do
    config(:default)
    |> Enum.into(%{})
    |> Map.merge(params)
    |> config(:provider).start()
  end

  @spec check(%{
          required(:phone_number) => PhoneVerification.PhoneNumber.t(),
          required(:verification_code) => PhoneVerification.verification_code()
        }) :: {:ok, %{message: String.t()}} | {:error, %{message: String.t(), code: String.t()}}
  def check(params) do
    config(:provider).check(params)
  end
end
