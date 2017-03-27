defmodule Til.Post do
  use Til.Web, :model

  schema "posts" do
    field :title, :string
    field :body, :string
    field :likes, :integer
    field :published_at, Ecto.DateTime
    field :slug, :string
    belongs_to :user, Til.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :likes, :published_at, :user_id, :slug])
    |> validate_required([:title, :body, :user_id])
    |> generate_slug
  end

  defp generate_slug(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{title: title}} ->
        _slug = title |> String.downcase |> String.replace(" ", "-")
        put_change(changeset, :slug, _slug)
      _ ->
        changeset
    end
  end
end
