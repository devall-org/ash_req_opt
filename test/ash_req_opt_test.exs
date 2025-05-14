defmodule AshReqOptTest do
  use ExUnit.Case, async: true

  alias Ash.Resource.Attribute
  alias Ash.Resource.Relationships.BelongsTo

  alias __MODULE__.{User, Post, Domain}

  defmodule User do
    use Ash.Resource,
      domain: Domain,
      data_layer: Ash.DataLayer.Ets,
      extensions: [AshReqOpt]

    ets do
      private?(true)
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Post do
    use Ash.Resource,
      domain: Domain,
      data_layer: Ash.DataLayer.Ets,
      extensions: [AshReqOpt]

    ets do
      private?(true)
    end

    attributes do
      uuid_primary_key(:id)
    end

    relationships do
      req_belongs_to(:author, User)
      opt_belongs_to(:reviewer, User)
    end
  end

  defmodule Domain do
    use Ash.Domain

    resources do
      resource(User)
      resource(Post)
    end
  end

  test "req, opt" do
    assert %Attribute{allow_nil?: false} = Ash.Resource.Info.attribute(User, :email)
    assert %Attribute{allow_nil?: true} = Ash.Resource.Info.attribute(User, :name)
  end

  test "req_belongs_to, opt_belongs_to" do
    assert %BelongsTo{allow_nil?: false} = Ash.Resource.Info.relationship(Post, :author)
    assert %BelongsTo{allow_nil?: true} = Ash.Resource.Info.relationship(Post, :reviewer)
  end
end
