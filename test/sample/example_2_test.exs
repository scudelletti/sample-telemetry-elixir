defmodule Sample.Example2Test do
  use ExUnit.Case

  alias Sample.CodeExample2, as: SUT

  test "sample test that receives message" do
    handler_name = "telemetry-test-handler"

    :ok =
      :telemetry.attach(
        handler_name,
        [:senrigan, :run, :stop],
        fn event, measurements, metadata, config ->
          send(self(), {:telemetry_event, event, measurements, metadata, config})
        end,
        :this_is_a_config
      )

    assert {:ok, 3} == SUT.run(1, 2)

    assert_receive {:telemetry_event, [:senrigan, :run, :stop], measurements, metadata,
                    :this_is_a_config}

    assert %{duration: _, monotonic_time: _} = measurements
    assert %{m: 1, n: 2, result: {:ok, 3}, telemetry_span_context: _} = metadata

    :ok = :telemetry.detach(handler_name)
  end
end
