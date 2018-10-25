defmodule PhoneVerification.PhoneNumber do
  @enforce_keys [:country_code, :subscriber_number]
  defstruct [:country_code, :subscriber_number]

  @type t() :: %__MODULE__{
          country_code: non_neg_integer() | String.t(),
          subscriber_number: String.t()
        }
end

defimpl String.Chars, for: PhoneVerification.PhoneNumber do
  def to_string(%{country_code: country_code, subscriber_number: subscriber_number}) do
    "+#{country_code}#{subscriber_number}"
  end
end
