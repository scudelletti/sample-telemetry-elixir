defmodule Sample.Example6Test do
  use ExUnit.Case
  use TelemetryTestHelper4

  alias Sample.CodeExample3, as: SUT

  # This could be defined in a different module
  def do_something(%{event: event, measurements: measurements, metadata: metadata, config: config}) do
    assert config == :this_is_a_config
    assert event == [:senrigan, :run, :stop]
    assert %{duration: _, monotonic_time: _} = measurements
    assert %{m: 1, n: 2, result: {:ok, 3}, telemetry_span_context: _} = metadata
  end

  test_with_telemetry "sample test that receives message", [:senrigan, :run, :stop] do
    assert {:ok, 3} == SUT.run(1, 2)

    assert_receive {:telemetry_event,
                    %{
                      config: :this_is_a_config,
                      event: [:senrigan, :run, :stop],
                      measurements: %{duration: _, monotonic_time: _},
                      metadata: %{m: 1, n: 2, result: {:ok, 3}, telemetry_span_context: _}
                    }}
  end

  test_with_telemetry "sample test that runs callback",
                      [:senrigan, :run, :stop],
                      &__MODULE__.do_something/1 do
    assert {:ok, 3} == SUT.run(1, 2)
  end
end
