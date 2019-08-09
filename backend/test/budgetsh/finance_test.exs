defmodule BudgetSH.FinanceTest do
  use BudgetSH.DataCase

  alias BudgetSH.Finance
  alias BudgetSH.Repo

  alias BudgetSH.Finance.Account

  @valid_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}
  @valid_user_attrs %{password: "some password", email: "username@example.com"}

  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Finance.create_account(user_fixture())

    account
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_user_attrs)
      |> BudgetSH.Accounts.create_user()

    user
  end

  test "list_accounts/0 returns all accounts" do
    account = account_fixture()

    list =
      Finance.list_accounts()
      |> Enum.map(fn acct -> Repo.preload(acct, :user) end)

    assert list == [account]
  end

  test "get_account!/1 returns the account with given id" do
    account = account_fixture()

    assert Finance.get_account!(account.id)
           |> Repo.preload(:user) == account
  end

  describe "create_account/2" do
    test "create_account/2 with valid data creates a account" do
      user = user_fixture()
      assert {:ok, %Account{} = account} = Finance.create_account(@valid_attrs, user)
      account = Repo.preload(account, :user)
      assert account.name == "some name"
      assert account.user == user
    end

    test "create_account/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_account(@invalid_attrs, user_fixture())
    end
  end

  test "update_account/2 with valid data updates the account" do
    account = account_fixture()
    assert {:ok, %Account{} = account} = Finance.update_account(account, @update_attrs)
    assert account.name == "some updated name"
  end

  test "update_account/2 with invalid data returns error changeset" do
    account = account_fixture()
    assert {:error, %Ecto.Changeset{}} = Finance.update_account(account, @invalid_attrs)
    assert account == Finance.get_account!(account.id) |> Repo.preload(:user)
  end

  test "delete_account/1 deletes the account" do
    account = account_fixture()
    assert {:ok, %Account{}} = Finance.delete_account(account)
    assert_raise Ecto.NoResultsError, fn -> Finance.get_account!(account.id) end
  end

  test "change_account/1 returns a account changeset" do
    account = account_fixture()
    assert %Ecto.Changeset{} = Finance.change_account(account)
  end
end