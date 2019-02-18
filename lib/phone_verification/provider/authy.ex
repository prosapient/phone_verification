defmodule PhoneVerification.Provider.Authy do
  @behaviour PhoneVerification.Provider

  @base_url "https://api.authy.com/protected/json/phones/verification/"
  # actually, it can be infinity, but we have to return a number
  @expiration_time_for_mock_phone_number_security_code 600

  @mock_carrier "life:) - Astelit"
  @supported_keys [:phone_number, :country_code, :via, :locale, :code_length, :custom_code]
  @impl true
  def start(%{phone_number: phone_number} = params) do
    if mock_number?(phone_number) do
      {:ok,
       %{
         seconds_to_expire: @expiration_time_for_mock_phone_number_security_code,
         message: "Requested verification using mock: #{phone_number}.",
         carrier: @mock_carrier
       }}
    else
      request(:post, "start", transform_params(params, @supported_keys))
    end
  end

  @supported_keys [:phone_number, :country_code, :verification_code]
  @impl true
  def check(%{phone_number: phone_number} = params) do
    if mock_number?(phone_number) do
      check_mock_number(params)
    else
      request(:get, "check", transform_params(params, @supported_keys))
    end
  end

  defp request(method, action, params) do
    with {:ok, %HTTPoison.Response{body: body}} <-
           HTTPoison.request(
             method,
             @base_url <> action,
             "",
             headers(),
             params: params
           ),
         {:ok, body} <- config(:json_codec).decode(body) do
      parse_body(action, body)
    else
      _ -> %{message: "Service unavailable", code: 503}
    end
  end

  defp parse_body(
         "start",
         %{
           "success" => true,
           "message" => message,
           "carrier" => carrier,
           "seconds_to_expire" => seconds_to_expire
         }
       ) do
    {:ok, %{message: message, carrier: carrier, seconds_to_expire: seconds_to_expire}}
  end

  defp parse_body("check", %{"success" => true, "message" => message}) do
    {:ok, %{message: message}}
  end

  defp parse_body(_action, %{"success" => false, "message" => message, "error_code" => error_code}) do
    {code, _} = Integer.parse(error_code)
    {:error, %{message: message, code: code}}
  end

  defp transform_params(%{phone_number: phone_number} = params, supported_keys) do
    params
    |> Map.merge(convert_phone_number(phone_number))
    |> Map.take(supported_keys)
  end

  defp convert_phone_number(%{
         country_code: country_code,
         subscriber_number: subscriber_number
       }) do
    %{
      country_code: country_code,
      phone_number: subscriber_number
    }
  end

  defp headers() do
    ["X-Authy-API-Key": config(:api_key)]
  end

  defp config(key) do
    __MODULE__
    |> PhoneVerification.config()
    |> Keyword.fetch!(key)
  end

  defp mock_number?(phone_number) do
    !is_nil(config(:mocks)[to_string(phone_number)])
  end

  defp check_mock_number(%{phone_number: phone_number, verification_code: code}) do
    if config(:mocks)[to_string(phone_number)] == code do
      {:ok, %{message: "Verification code is correct."}}
    else
      {:error, %{message: "Verification code is incorrect", code: 60_022}}
    end
  end
end
