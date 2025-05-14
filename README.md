# AshReqOpt

An extension library for the Ash framework that provides clearer ways to define required and optional attributes and relationships in your resources.

## Features

- Define required attributes and relationships:
  - Public:
    - `req :email, :string` instead of `attribute :email, :string, allow_nil?: false, public?: true`
    - `req_belongs_to :company, Company` instead of `belongs_to :company, Company, allow_nil?: false, public?: true`
  - Private:
    - `req_prv :password_hash, :string` instead of `attribute :password_hash, :string, allow_nil?: false, public?: false`
    - `req_prv_belongs_to :created_by, User` instead of `belongs_to :created_by, User, allow_nil?: false, public?: false`

- Define optional attributes and relationships:
  - Public:
    - `opt :name, :string` instead of `attribute :name, :string, allow_nil?: true, public?: true`
    - `opt_belongs_to :manager, User` instead of `belongs_to :manager, User, allow_nil?: true, public?: true`
  - Private:
    - `opt_prv :last_login_at, :utc_datetime` instead of `attribute :last_login_at, :utc_datetime, allow_nil?: true, public?: false`
    - `opt_prv_belongs_to :updated_by, User` instead of `belongs_to :updated_by, User, allow_nil?: true, public?: false`

- Original macros still work:
  - `attribute :nickname, :string, allow_nil?: true`
  - `belongs_to :department, Department, allow_nil?: true`

- Extends Ash resource DSL for more explicit intent

## Installation

Add `ash_req_opt` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ash_req_opt, "~> 0.2.0"}
  ]
end
```

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

## License

MIT

