# Rules for working with AshReqOpt

AshReqOpt provides shortcut DSL macros for attributes and belongs_to relationships in Ash resources with predefined `allow_nil?` and `public?` values.

## Setup

```elixir
defmodule MyApp.User do
  use Ash.Resource, extensions: [AshReqOpt]

  attributes do
    req :email, :string       # allow_nil?: false, public?: true
    opt :name, :string        # allow_nil?: true, public?: true
  end
end
```

## Attribute Shortcuts

| Macro | allow_nil? | public? |
|:---:|:----------:|:-------:|
| `req` | false | true |
| `req_prv` | false | false |
| `opt` | true | true |
| `opt_prv` | true | false |

```elixir
attributes do
  req :email, :string              # Required public
  req_prv :password_hash, :string  # Required private
  opt :bio, :string                # Optional public
  opt_prv :last_login_at, :utc_datetime  # Optional private
end
```

## Belongs_to Shortcuts

| Macro | allow_nil? | public? |
|:---:|:----------:|:-------:|
| `req_belongs_to` | false | true |
| `req_prv_belongs_to` | false | false |
| `opt_belongs_to` | true | true |
| `opt_prv_belongs_to` | true | false |

```elixir
relationships do
  req_belongs_to :company, Company          # Required public
  req_prv_belongs_to :created_by, User      # Required private
  opt_belongs_to :manager, User             # Optional public
  opt_prv_belongs_to :updated_by, User      # Optional private
end
```

## Mixing with Standard Ash DSL

All standard attribute and belongs_to options still work. Can freely mix with standard Ash macros:

```elixir
attributes do
  req :email, :string do
    constraints [match: ~r/@/]
  end
  
  attribute :status, :atom, allow_nil?: false, public?: true
end

relationships do
  req_belongs_to :company, Company
  has_many :posts, Post
end
```

