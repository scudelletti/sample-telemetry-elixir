defmodule Sample.Example1Test do
  use ExUnit.Case

  alias Sample.CodeExample1, as: SUT

  test "sample test" do
    assert {:ok, 3} = SUT.run(1, 2)
  end
end
