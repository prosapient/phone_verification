defmodule PhoneVerification do
  @moduledoc """
  Documentation for PhoneVerification.
  """
  @behaviour PhoneVerification.Provider

  def config(key) do
    Application.get_env(:phone_verification, key)
  end

  @impl true
  def start(params) do
    config(:default)
    |> Enum.into(%{})
    |> Map.merge(params)
    |> config(:provider).start()
  end

  @impl true
  def check(params) do
    config(:provider).check(params)
  end
end
