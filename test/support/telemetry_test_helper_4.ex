defmodule TelemetryTestHelper4 do
  use ExUnit.Case

  defmacro __using__(_opts) do
    quote do
      require TelemetryTestHelper4
      import TelemetryTestHelper4
    end
  end

  defmacro test_with_telemetry(test_name, event_name, do: test_runner) do
    quote do
      test unquote(test_name) do
        TelemetryTestHelper4.listen(unquote(event_name))

        unquote(test_runner)
      end
    end
  end

  defmacro test_with_telemetry(test_name, event_name, fun, do: test_runner) do
    quote do
      test unquote(test_name) do
        TelemetryTestHelper4.listen(unquote(event_name))
        unquote(test_runner)

        assert_receive {:telemetry_event, telemetry_event}

        unquote(fun).(telemetry_event)
      end
    end
  end

  def listen(event_name) do
    handler_name = "telemetry-test-handler"

    :ok =
      :telemetry.attach(
        handler_name,
        event_name,
        fn event, measurements, metadata, config ->
          send(
            self(),
            {:telemetry_event,
             %{
               event: event,
               measurements: measurements,
               metadata: metadata,
               config: config
             }}
          )
        end,
        :this_is_a_config
      )

    on_exit(fn ->
      :ok = :telemetry.detach(handler_name)
    end)
  end
end
