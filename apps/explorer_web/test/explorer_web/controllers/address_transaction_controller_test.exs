defmodule ExplorerWeb.AddressTransactionControllerTest do
  use ExplorerWeb.ConnCase

  import ExplorerWeb.Router.Helpers, only: [address_transaction_path: 4]

  alias Explorer.ExchangeRates.Token

  describe "GET index/2" do
    test "with invalid address hash", %{conn: conn} do
      conn = get(conn, address_transaction_path(conn, :index, :en, "invalid_address"))

      assert html_response(conn, 404)
    end

    test "with valid address hash without address", %{conn: conn} do
      conn = get(conn, address_transaction_path(conn, :index, :en, "0x8bf38d4764929064f2d4d3a56520a76ab3df415b"))

      assert html_response(conn, 404)
    end

    test "returns transactions to this address", %{conn: conn} do
      address = insert(:address)
      block = insert(:block)
      transaction = insert(:transaction, block_hash: block.hash, index: 0, to_address_hash: address.hash)
      insert(:receipt, transaction_hash: transaction.hash, transaction_index: transaction.index)

      conn = get(conn, address_transaction_path(ExplorerWeb.Endpoint, :index, :en, address))

      transaction_hashes =
        conn.assigns.page
        |> Enum.map(fn transaction -> transaction.hash end)

      assert conn.status == 200
      assert Enum.member?(transaction_hashes, transaction.hash)
    end

    test "does not return transactions from this address", %{conn: conn} do
      block = insert(:block)
      transaction = insert(:transaction, block_hash: block.hash, index: 0)
      insert(:receipt, transaction_hash: transaction.hash, transaction_index: transaction.index)
      address = insert(:address)

      conn = get(conn, address_transaction_path(ExplorerWeb.Endpoint, :index, :en, address))

      assert conn.status == 200
      assert Enum.empty?(conn.assigns.page)
    end

    test "does not return related transactions without a receipt", %{conn: conn} do
      address = insert(:address)
      block = insert(:block)

      insert(
        :transaction,
        block_hash: block.hash,
        from_address_hash: address.hash,
        index: 0,
        to_address_hash: address.hash
      )

      conn = get(conn, address_transaction_path(ExplorerWeb.Endpoint, :index, :en, address))

      assert conn.status == 200
      assert Enum.empty?(conn.assigns.page)
    end

    test "does not return related transactions without a from address", %{conn: conn} do
      block = insert(:block)
      transaction = insert(:transaction, block_hash: block.hash, index: 0)
      insert(:receipt, transaction_hash: transaction.hash, transaction_index: transaction.index)
      address = insert(:address)

      conn = get(conn, address_transaction_path(ExplorerWeb.Endpoint, :index, :en, address), filter: "from")

      assert conn.status == 200
      assert Enum.empty?(conn.assigns.page)
    end

    test "does not return related transactions without a to address", %{conn: conn} do
      address = insert(:address)
      block = insert(:block)
      transaction = insert(:transaction, block_hash: block.hash, index: 0, from_address_hash: address.hash, index: 0)
      insert(:receipt, transaction_hash: transaction.hash, transaction_index: transaction.index)

      conn = get(conn, address_transaction_path(ExplorerWeb.Endpoint, :index, :en, address), filter: "to")

      assert conn.status == 200
      assert Enum.empty?(conn.assigns.page)
    end

    test "includes USD exchange rate value for address in assigns", %{conn: conn} do
      address = insert(:address)

      conn = get(conn, address_transaction_path(ExplorerWeb.Endpoint, :index, :en, address.hash))

      assert %Token{} = conn.assigns.exchange_rate
    end
  end
end
