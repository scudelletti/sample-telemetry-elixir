defmodule TelemetryTestHelper2 do
  use GenServer
  use ExUnit.Case

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:set, ref, args}, _from, state) do
    new_state = Map.put(state, ref, args)
    {:reply, :ok, new_state}
  end

  def handle_call({:get, ref}, _from, state) do
    {result, new_state} = Map.pop(state, ref)

    {:reply, {:ok, result}, new_state}
  end

  def telemetry_listen(%{
        telemetry_listen: event_name,
        telemetry_listen_fn: telemetry_listen_fn,
        test: test_name
      }) do
    test_ref = make_ref()
    handler_name = "#{test_name}-handler"

    attach_helper(handler_name, event_name, fn event, measurements, metadata, config ->
      :ok =
        GenServer.call(
          __MODULE__,
          {:set, test_ref,
           %{event: event, measurements: measurements, metadata: metadata, config: config}}
        )
    end)

    on_exit(fn ->
      :ok = :telemetry.detach(handler_name)

      {:ok, result} = GenServer.call(__MODULE__, {:get, test_ref})
      telemetry_listen_fn.(result)
    end)
  end

  def telemetry_listen(%{telemetry_listen: event_name, test: test_name}) do
    handler_name = "#{test_name}-handler"

    attach_helper(handler_name, event_name, fn event, measurements, metadata, config ->
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
    end)

    on_exit(fn ->
      :ok = :telemetry.detach(handler_name)
    end)
  end

  def telemetry_listen(context), do: context

  defp attach_helper(handler_name, event_name, callback_fn) do
    :ok =
      :telemetry.attach(
        handler_name,
        event_name,
        callback_fn,
        :this_is_a_config
      )
  end
end
