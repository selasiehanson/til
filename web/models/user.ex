defmodule Til.User do
  use Til.Web, :model

  schema "users" do
    field :email, :string
    field :username, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :username, :password])
    |> validate_required([:email, :username, :password])
  end


  def signup_changeset(struct, params \\ %{}) do  
    struct 
    |> cast(params, [:email, :username, :password])
    |> validate_required([:email, :password, :username])
    |> validate_length(:password, min: 6, max: 255)
    |> validate_format(:email, ~r/\A[^@\s]+@[^@\s]+\z/)
    |> encrypt_password
  end

  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} -> 
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
