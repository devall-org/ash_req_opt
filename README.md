# AshReqOpt

Concise DSL for attributes and relationships in Ash resources.


### Attribute DSL

| DSL | allow_nil? | public? |
|:---:|:----------:|:-------:|
| `req` | false | true |
| `req_prv` | false | false |
| `opt` | true | true |
| `opt_prv` | true | false |

### Relationship DSL

| DSL | allow_nil? | public? |
|:---:|:----------:|:-------:|
| `req_belongs_to` | false | true |
| `req_prv_belongs_to` | false | false |
| `opt_belongs_to` | true | true |
| `opt_prv_belongs_to` | true | false |

## Usage Example

```elixir
defmodule MyApp.User do
  use Ash.Resource, extensions: [AshReqOpt]

  attributes do
    uuid_primary_key :id

    # Required attributes
    req :email, :string    # allow_nil?: false, public?: true
    req_prv :password_hash, :string    # allow_nil?: false, public?: false

    # Optional attributes
    opt :name, :string     # allow_nil?: true, public?: true
    opt_prv :last_login_at, :utc_datetime  # allow_nil?: true, public?: false

    # Original attribute macro still works
    attribute :nickname, :string, allow_nil?: true
  end

  relationships do
    # Required relationships
    req_belongs_to :company, Company    # allow_nil?: false, public?: true
    req_prv_belongs_to :created_by, User    # allow_nil?: false, public?: false

    # Optional relationships
    opt_belongs_to :manager, User       # allow_nil?: true, public?: true
    opt_prv_belongs_to :updated_by, User    # allow_nil?: true, public?: false

    # Original belongs_to macro still works
    belongs_to :department, Department, allow_nil?: true
  end
end
```

## Installation

Add `ash_req_opt` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ash_req_opt, "~> 0.2.0"}
  ]
end
```

## License

MIT

