defmodule ExplorerWeb.TransactionLogView do
  use ExplorerWeb, :view
  @dialyzer :no_match

  alias ExplorerWeb.TransactionView

  defdelegate formatted_usd(txn, token), to: TransactionView
end
