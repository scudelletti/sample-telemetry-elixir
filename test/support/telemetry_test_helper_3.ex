defmodule TelemetryTestHelper3 do
  use ExUnit.Case

  def capture_telemetry(event_name, fun) do
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

    fun.()

    assert_receive {:telemetry_event, telemetry_event}
    :ok = :telemetry.detach(handler_name)

    telemetry_event
  end
end
