defmodule Sample.Example5Test do
  use ExUnit.Case
  import TelemetryTestHelper3

  alias Sample.CodeExample3, as: SUT

  test "sample test" do
    telemetry_event =
      capture_telemetry([:senrigan, :run, :stop], fn ->
        assert {:ok, 3} == SUT.run(1, 2)
      end)

    assert %{
             config: :this_is_a_config,
             event: [:senrigan, :run, :stop],
             measurements: %{duration: _, monotonic_time: _},
             metadata: %{m: 1, n: 2, result: {:ok, 3}, telemetry_span_context: _}
           } = telemetry_event
  end
end
