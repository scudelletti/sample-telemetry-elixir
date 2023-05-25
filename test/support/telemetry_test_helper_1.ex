defmodule TelemetryTestHelper1 do
  use ExUnit.Case

  def telemetry_listen(%{telemetry_listen: event_name}) do
    handler_name = "telemetry-test-handler"

    :ok =
      :telemetry.attach(
        handler_name,
        event_name,
        fn event, measurements, metadata, config ->
          send(self(), {:telemetry_event, event, measurements, metadata, config})
        end,
        :this_is_a_config
      )

    on_exit(fn ->
      :ok = :telemetry.detach(handler_name)
    end)
  end
end
