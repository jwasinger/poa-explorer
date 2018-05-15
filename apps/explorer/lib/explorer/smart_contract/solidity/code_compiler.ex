defmodule Explorer.SmartContract.Solidity.CodeCompiler do
  def run(name, code, address) do
    {:ok, file_name} = settings_file(name, code, address)

    port = Port.open({:spawn, "cat #{file_name} | solc --standard-json"}, [:binary])

    receive do
      {^port, {:data, result}} ->

      result
    end
  end

  def settings_file(name, code, address) do
    settings = """
    {
      "language": "Solidity",
      "sources": {
        "#{name}":
        {
          "content": "#{code}"
        }
      },
      "settings": {
        "outputSelection": {
          "*": {
            "*": [ "metadata", "evm.bytecode" ]
          },
          "def": {
            "MyContract": [ "abi", "evm.bytecode.opcodes" ]
          }
        }
      }
    }
    """

    file_name = "temp/settings_#{address}.json"

    File.mkdir_p(".temp/")

    Path.expand("./#{file_name}")
    |> Path.absname
    |> File.write(settings, [:write])

    {:ok, file_name}
  end
end
