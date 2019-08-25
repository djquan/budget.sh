defmodule BudgetSHWeb.Schema.Schema do
  use Absinthe.Schema
  alias BudgetSHWeb.Resolvers
  alias BudgetSHWeb.Schema.Middleware
  import_types(Absinthe.Type.Custom)

  query do
    @desc "Get info on the currently logged in user"
    field :me, :user do
      middleware(Middleware.Authenticate)
      resolve(&Resolvers.Accounts.me/3)
    end
  end

  mutation do
    @desc "Create a user account"
    field :signup, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Accounts.signup/3)
    end

    @desc "Sign in user account"
    field :signin, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Accounts.signin/3)
    end

    @desc "Create an account"
    field :create_account, :account do
      arg(:name, non_null(:string))
      arg(:user_account, :boolean)
      middleware(Middleware.Authenticate)
      resolve(&Resolvers.Finance.create_account/3)
    end
  end

  object :user do
    field :email, non_null(:string)
  end

  object :session do
    field :user, non_null(:user)
    field :session, non_null(:string)
  end

  object :account do
    field :name, non_null(:string)
    field :user_account, non_null(:boolean)
    field :public_id, non_null(:string)
  end

  def context(ctx), do: ctx
end
