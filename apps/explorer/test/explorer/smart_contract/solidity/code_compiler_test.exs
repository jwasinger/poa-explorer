defmodule Explorer.SmartContract.Solidity.CodeCompilerTest do
  use ExUnit.Case, async: true

  doctest Explorer.SmartContract.Solidity.CodeCompiler

  alias Explorer.SmartContract.Solidity.CodeCompiler

  describe "run" do
    test "compiles a smart contract using the solidity command line" do
      address = "0xfb0929a9b37041c519b4e0437b6078ff7632b2d6"
      name = "SimpleStorage"
      code = """
      contract SimpleStorage {
          uint storedData;

          function set(uint x) public {
              storedData = x;
          }

          function get() public constant returns (uint) {
              return storedData;
          }
      }
      """

      response = CodeCompiler.run(name, code, address)
                 |> Jason.decode!

      assert response["contracts"] != nil
    end
  end

  describe "settings_file" do
    test "creates a json file with the solidity compiler expected settings" do
      address = "0xfb0929a9b37041c519b4e0437b6078ff7632b2d6"
      name = "SimpleStorage"
      code = """
      contract SimpleStorage {
          uint storedData;

          function set(uint x) public {
              storedData = x;
          }

          function get() public constant returns (uint) {
              return storedData;
          }
      }
      """

      {:ok, file_name} = CodeCompiler.settings_file(name, code, address)

      assert File.exists?("./#{file_name}") == true
    end
  end
end
