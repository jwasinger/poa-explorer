defmodule ExplorerWeb.AddressView do
  use ExplorerWeb, :view

  alias Explorer.Chain.{Address, Wei}
  alias Explorer.ExchangeRates.Token

  @dialyzer :no_match

  def balance(%Address{fetched_balance: nil}), do: ""

  @doc """
  Returns a formatted address balance and includes the unit.
  """
  def balance(%Address{fetched_balance: balance}) do
    format_wei_value(balance, :ether, fractional_digits: 18)
  end

  def formatted_usd(_, %Token{usd_value: nil}), do: nil
  def formatted_usd(%Address{fetched_balance: nil}, _), do: nil

  def formatted_usd(%Address{fetched_balance: balance}, %Token{usd_value: usd_value}) do
    with {:ok, wei} <- Wei.cast(balance),
         ether <- Wei.to(wei, :ether),
         usd <- Decimal.mult(ether, usd_value),
         {:ok, formatted} <- Cldr.Number.to_string(usd) do
      "$#{formatted} " <> gettext("USD")
    else
      _ -> nil
    end
  end
end
