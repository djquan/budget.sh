defmodule BudgetSHWeb.Schema.Middleware.Authenticate do
  @behaviour Absinthe.Middleware

  @spec call(Absinthe.Resolution.t(), any) :: Absinthe.Resolution.t()
  def call(resolution, _) do
    case resolution.context do
      %{current_user: _} ->
        resolution

      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "Sign in before proceeding"})
    end
  end
end
