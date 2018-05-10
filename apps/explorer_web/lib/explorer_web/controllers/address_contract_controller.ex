defmodule ExplorerWeb.AddressContractController do
  use ExplorerWeb, :controller

  alias Explorer.{Chain, Repo}
  alias Explorer.Chain.InternalTransaction

  import Ecto.Query, only: [from: 2]

  def index(conn, %{"address_id" => address_hash_string}) do
    with {:ok, address_hash} <- Chain.string_to_address_hash(address_hash_string),
         {:ok, internal_transaction} <- get_internal_transaction(address_hash) do
      render(
        conn,
        "index.html",
        address: internal_transaction.from_address,
        internal_transaction: internal_transaction
      )
    else
      :error ->
        not_found(conn)

      {:error, :not_found} ->
        not_found(conn)
    end
  end

  defp get_internal_transaction(hash) do
    query =
      from(
        internal_transaction in InternalTransaction,
        where:
          internal_transaction.from_address_hash == ^hash and
            is_nil(internal_transaction.to_address_hash) and
            not is_nil(internal_transaction.created_contract_code),
        preload: [:from_address]
      )

    query
    |> Repo.all()
    |> List.first()
    |> case do
      nil -> {:error, :not_found}
      internal_transaction -> {:ok, internal_transaction}
    end
  end
end
