defmodule Sample.CodeExample3 do
  use TelemetryDecorator

  @decorate telemetry([:senrigan, :run], include: [:m, :n])
  def run(m, n) do
    {:ok, m + n}
  end
end
