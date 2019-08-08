defmodule BudgetSH.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:accounts, [:user_id])
  end
end
