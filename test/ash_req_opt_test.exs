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
      private? true
    end

    attributes do
      uuid_primary_key :id
    end
  end

  defmodule Post do
    use Ash.Resource,
      domain: Domain,
      data_layer: Ash.DataLayer.Ets,
      extensions: [AshReqOpt]

    ets do
      private? true
    end

    attributes do
      uuid_primary_key :id

      req :req, :string
      req_prv :req_prv, :string

      opt :opt, :string
      opt_prv :opt_prv, :string
    end

    relationships do
      req_belongs_to :req_user, User
      req_prv_belongs_to :req_prv_user, User

      opt_belongs_to :opt_user, User
      opt_prv_belongs_to :opt_prv_user, User
    end
  end

  defmodule Domain do
    use Ash.Domain

    resources do
      resource User
      resource Post
    end
  end

  test "req, opt, req_prv, opt_prv" do
    assert %Attribute{allow_nil?: false, public?: true} =
             Ash.Resource.Info.attribute(Post, :req)

    assert %Attribute{allow_nil?: false, public?: false} =
             Ash.Resource.Info.attribute(Post, :req_prv)

    assert %Attribute{allow_nil?: true, public?: true} =
             Ash.Resource.Info.attribute(Post, :opt)

    assert %Attribute{allow_nil?: true, public?: false} =
             Ash.Resource.Info.attribute(Post, :opt_prv)
  end

  test "req_belongs_to, opt_belongs_to, req_prv_belongs_to, opt_prv_belongs_to" do
    assert %BelongsTo{allow_nil?: false, public?: true} =
             Ash.Resource.Info.relationship(Post, :req_user)

    assert %BelongsTo{allow_nil?: false, public?: false} =
             Ash.Resource.Info.relationship(Post, :req_prv_user)

    assert %BelongsTo{allow_nil?: true, public?: true} =
             Ash.Resource.Info.relationship(Post, :opt_user)

    assert %BelongsTo{allow_nil?: true, public?: false} =
             Ash.Resource.Info.relationship(Post, :opt_prv_user)
  end
end
