# AshReqOpt

An extension library for the Ash framework that provides clearer ways to define required and optional attributes and relationships in your resources.

## Features

- Define required/optional attributes using `req` and `opt` macros
  - Instead of `attribute :email, :string, allow_nil?: false`, use `req :email, :string`
  - Instead of `attribute :name, :string, allow_nil?: true`, use `opt :name, :string`
  - You can still use the original `attribute` macro if you prefer
- Define required/optional relationships using `req_belongs_to` and `opt_belongs_to` macros
  - Instead of `belongs_to :company, Company, allow_nil?: false`, use `req_belongs_to :company, Company`
  - Instead of `belongs_to :manager, User, allow_nil?: true`, use `opt_belongs_to :manager, User`
  - You can still use the original `belongs_to` macro if you prefer
- Extends Ash resource DSL for more explicit intent

## Installation

Add `ash_req_opt` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ash_req_opt, "~> 0.1.0"}
  ]
end
```

## Usage Example

```elixir
defmodule MyApp.User do
  use Ash.Resource,
    extensions: [AshReqOpt]

  attributes do
    uuid_primary_key :id
    req :email, :string    # Required attribute (equivalent to allow_nil?: false)
    opt :name, :string     # Optional attribute (equivalent to allow_nil?: true)
    attribute :nickname, :string, allow_nil?: true  # Original attribute macro still works
  end

  relationships do
    req_belongs_to :company, Company    # Required relationship (equivalent to allow_nil?: false)
    opt_belongs_to :manager, User       # Optional relationship (equivalent to allow_nil?: true)
    belongs_to :department, Department, allow_nil?: true  # Original belongs_to macro still works
  end
end
```

## License

MIT

