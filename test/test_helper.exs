ExUnit.start()

{:ok, _} = GenServer.start(TelemetryTestHelper2, nil, name: TelemetryTestHelper2)
