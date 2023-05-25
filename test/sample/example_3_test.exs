defmodule Sample.Example3Test do
  use ExUnit.Case
  import TelemetryTestHelper1

  alias Sample.CodeExample3, as: SUT

  setup [:telemetry_listen]

  @tag telemetry_listen: [:senrigan, :run, :stop]
  test "sample test that receives message" do
    assert {:ok, 3} == SUT.run(1, 2)

    assert_receive {:telemetry_event, [:senrigan, :run, :stop], measurements, metadata,
                    :this_is_a_config}

    assert %{duration: _, monotonic_time: _} = measurements
    assert %{m: 1, n: 2, result: {:ok, 3}, telemetry_span_context: _} = metadata
  end
end
