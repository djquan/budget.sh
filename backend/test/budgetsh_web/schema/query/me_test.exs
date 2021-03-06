defmodule BudgetSH.Scheam.Query.MeTest do
  use BudgetSHWeb.ConnCase, async: true

  @query """
  {
    me {
      email
    }
  }
  """

  @valid_attrs %{password: "some password", email: "username@example.com"}
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> BudgetSH.Accounts.create_user()

    user
  end

  test "me returns email" do
    user = user_fixture()
    session = BudgetSHWeb.AuthToken.sign(user)

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{session}")
      |> get("/", query: @query)

    assert %{
             "data" => %{
               "me" => %{
                 "email" => "username@example.com"
               }
             }
           } = json_response(conn, 200)
  end

  test "me returns nil if not signed in" do
    conn = get build_conn(), "/", query: @query

    assert %{
             "data" => %{
               "me" => nil
             }
           } = json_response(conn, 200)
  end
end
