defmodule ExplorerWeb.AddressContractControllerTest do
  use ExplorerWeb.ConnCase

  import ExplorerWeb.Router.Helpers, only: [address_contract_path: 4]

  describe "GET index/3" do
    test "without address", %{conn: conn} do
      conn =
        conn
        |> get(address_contract_path(ExplorerWeb.Endpoint, :index, :en, "0xcafe"))

      assert html_response(conn, 404)
    end

    test "returns a internal_transaction with a contract_code", %{conn: conn} do
      address = insert(:address)

      internal_transaction =
        insert(:internal_transaction, from_address_hash: address.hash, to_address_hash: nil)

      conn = get(conn, address_contract_path(ExplorerWeb.Endpoint, :index, :en, address))

      assert html_response(conn, 200)
      assert conn.assigns.address.hash == address.hash
      assert conn.assigns.internal_transaction.id == internal_transaction.id
    end
  end
end
