defmodule AshReqOpt do
  defmodule ReqOptAttribute do
    @schema Ash.Resource.Attribute.attribute_schema()
            |> Keyword.reject(fn
              {:allow_nil?, _} -> true
              _ -> false
            end)

    # Based on Ash's lib/ash/resource/dsl.ex
    @req %Spark.Dsl.Entity{
      name: :req,
      describe: """
      Declares an attribute on the resource with allow_nil?: false.
      """,
      examples: [
        """
        req :name, :string do
          default "John Doe"
        end
        """
      ],
      transform: {__MODULE__, :req_transform, []},
      target: Ash.Resource.Attribute,
      args: [:name, :type],
      schema: @schema
    }

    @opt %Spark.Dsl.Entity{
      name: :opt,
      describe: """
      Declares an attribute on the resource with allow_nil?: true.
      """,
      examples: [
        """
        opt :name, :string do
          default nil
        end
        """
      ],
      transform: {__MODULE__, :opt_transform, []},
      target: Ash.Resource.Attribute,
      args: [:name, :type],
      schema: @schema
    }

    def req_transform(attribute) do
      %{attribute | allow_nil?: false} |> Ash.Resource.Attribute.transform()
    end

    def opt_transform(attribute) do
      %{attribute | allow_nil?: true} |> Ash.Resource.Attribute.transform()
    end

    @add_req %Spark.Dsl.Patch.AddEntity{
      section_path: [:attributes],
      entity: @req
    }

    @add_opt %Spark.Dsl.Patch.AddEntity{
      section_path: [:attributes],
      entity: @opt
    }

    def add_req, do: @add_req
    def add_opt, do: @add_opt
  end

  defmodule ReqOptBelongsTo do
    @schema Ash.Resource.Relationships.BelongsTo.opt_schema()
            |> Keyword.reject(fn
              {:allow_nil?, _} -> true
              _ -> false
            end)

    # Based on Ash's lib/ash/resource/dsl.ex
    @req_belongs_to %Spark.Dsl.Entity{
      name: :req_belongs_to,
      describe: """
      Same as belongs_to but with allow_nil?: false.
      """,
      examples: [
        """
        req_belongs_to :company, Company
        """
      ],
      no_depend_modules: [:destination],
      target: Ash.Resource.Relationships.BelongsTo,
      schema: @schema,
      transform: {__MODULE__, :transform, [false]},
      args: [:name, :destination],
      auto_set_fields: [
        attribute_writable?: true
      ]
    }

    @opt_belongs_to %Spark.Dsl.Entity{
      name: :opt_belongs_to,
      describe: """
      Same as belongs_to but with allow_nil?: true.
      """,
      examples: [
        """
        opt_belongs_to :company, Company
        """
      ],
      no_depend_modules: [:destination],
      target: Ash.Resource.Relationships.BelongsTo,
      schema: @schema,
      transform: {__MODULE__, :transform, [true]},
      args: [:name, :destination],
      auto_set_fields: [
        attribute_writable?: true
      ]
    }

    def transform(attribute, allow_nil?) do
      %{attribute | allow_nil?: allow_nil?} |> Ash.Resource.Relationships.BelongsTo.transform()
    end

    @add_req %Spark.Dsl.Patch.AddEntity{
      section_path: [:relationships],
      entity: @req_belongs_to
    }

    @add_opt %Spark.Dsl.Patch.AddEntity{
      section_path: [:relationships],
      entity: @opt_belongs_to
    }

    def add_req, do: @add_req
    def add_opt, do: @add_opt
  end

  use Spark.Dsl.Extension,
    dsl_patches: [
      ReqOptAttribute.add_req(),
      ReqOptAttribute.add_opt(),
      ReqOptBelongsTo.add_req(),
      ReqOptBelongsTo.add_opt()
    ]
end
