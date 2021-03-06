defmodule BudgetSH.Finance.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias BudgetSH.Accounts.User
  alias BudgetSH.Finance.Account

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :name, :string
    field :user_account, :boolean, default: false
    belongs_to :user, BudgetSH.Accounts.User
    has_many :transactions, BudgetSH.Finance.Transaction
    timestamps()
  end

  @spec changeset(%Account{}, %{}) :: Ecto.Changeset.t()
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :user_account])
    |> unique_constraint(:name,
      message: "Name already exists",
      name: "user_account_name_unique_index"
    )
    |> validate_required([:name])
  end

  @spec user_scoped(%User{}) :: Ecto.Query.t()
  def user_scoped(user) do
    from(a in __MODULE__, where: a.user_id == ^user.id)
  end
end
