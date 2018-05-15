defmodule Explorer.SmartContract.Solidity.CompilerVersion do
  @moduledoc """
  Adapter for fetching compiler versions from https://solc-bin.ethereum.org/bin/list.json.
  """

  alias HTTPoison.{Error, Response}

  @doc """
  Fetches list of compilers from Ethereum Solidity API.
  """
  def fetch_versions() do
    headers = [{"Content-Type", "application/json"}]

    case HTTPoison.get(source_url(), headers) do
      {:ok, %Response{body: body, status_code: 200}} ->
        {:ok, decode_json(body)["releases"]}

      {:ok, %Response{body: body, status_code: status_code}} when status_code in 400..499 ->
        {:error, decode_json(body)["error"]}

      {:error, %Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp decode_json(json) do
    Jason.decode!(json)
  end

  defp source_url do
    solc_bin = Application.get_env(:explorer, __MODULE__, :solc_bin_api_url)

    "#{solc_bin[:solc_bin_api_url]}/bin/list.json"
  end
end
