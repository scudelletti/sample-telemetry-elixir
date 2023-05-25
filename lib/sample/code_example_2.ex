defmodule Sample.CodeExample2 do
  def run(m, n) do
    :telemetry.span(
      [:senrigan, :run],
      %{metadata: :yeap, foo: :bar},
      fn ->
        response = {:ok, m + 2}
        {response, %{m: m, n: n, result: response}}
      end
    )
  end
end
