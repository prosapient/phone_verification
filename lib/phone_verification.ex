defmodule PhoneVerification do
  @behaviour PhoneVerification.Provider

  def config(key) do
    Application.get_env(:phone_verification, key)
  end

  def start(params) do
    config(:default)
    |> Enum.into(%{})
    |> Map.merge(params)
    |> config(:provider).start()
  end

  def check(params) do
    config(:provider).check(params)
  end
end
