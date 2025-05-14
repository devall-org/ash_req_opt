defmodule AshReqOpt do
  defmodule ReqOptAttribute do
    @schema Ash.Resource.Attribute.attribute_schema()
            |> Keyword.reject(fn
              {:allow_nil?, _} -> true
              {:public?, _} -> true
              _ -> false
            end)

    # Based on Ash's lib/ash/resource/dsl.ex
    @req %Spark.Dsl.Entity{
      name: :req,
      describe: """
      Declares an attribute on the resource with allow_nil?: false and public?: true.
      """,
      examples: [
        """
        req :name, :string do
          default "John Doe"
        end
        """
      ],
      transform: {Ash.Resource.Attribute, :transform, []},
      target: Ash.Resource.Attribute,
      args: [:name, :type],
      schema: @schema,
      auto_set_fields: [
        allow_nil?: false,
        public?: true
      ]
    }

    @req_prv %Spark.Dsl.Entity{
      name: :req_prv,
      describe: """
      Declares an attribute on the resource with allow_nil?: false and public?: false.
      """,
      examples: [
        """
        req_prv :name, :string do
          default "John Doe"
        end
        """
      ],
      transform: {Ash.Resource.Attribute, :transform, []},
      target: Ash.Resource.Attribute,
      args: [:name, :type],
      schema: @schema,
      auto_set_fields: [
        allow_nil?: false,
        public?: false
      ]
    }

    @opt %Spark.Dsl.Entity{
      name: :opt,
      describe: """
      Declares an attribute on the resource with allow_nil?: true and public?: true.
      """,
      examples: [
        """
        opt :name, :string do
          default nil
        end
        """
      ],
      transform: {Ash.Resource.Attribute, :transform, []},
      target: Ash.Resource.Attribute,
      args: [:name, :type],
      schema: @schema,
      auto_set_fields: [
        allow_nil?: true,
        public?: true
      ]
    }

    @opt_prv %Spark.Dsl.Entity{
      name: :opt_prv,
      describe: """
      Declares an attribute on the resource with allow_nil?: true and public?: false.
      """,
      examples: [
        """
        opt_prv :name, :string do
          default nil
        end
        """
      ],
      transform: {Ash.Resource.Attribute, :transform, []},
      target: Ash.Resource.Attribute,
      args: [:name, :type],
      schema: @schema,
      auto_set_fields: [
        allow_nil?: true,
        public?: false
      ]
    }

    # def transform(attribute, allow_nil?: allow_nil?, public?: public?) do
    #   %{attribute | allow_nil?: allow_nil?, public?: public?}
    #   |> Ash.Resource.Attribute.transform()
    # end

    def patches() do
      [
        %Spark.Dsl.Patch.AddEntity{
          section_path: [:attributes],
          entity: @req
        },
        %Spark.Dsl.Patch.AddEntity{
          section_path: [:attributes],
          entity: @req_prv
        },
        %Spark.Dsl.Patch.AddEntity{
          section_path: [:attributes],
          entity: @opt
        },
        %Spark.Dsl.Patch.AddEntity{
          section_path: [:attributes],
          entity: @opt_prv
        }
      ]
    end
  end

  defmodule ReqOptBelongsTo do
    @schema Ash.Resource.Relationships.BelongsTo.opt_schema()
            |> Keyword.reject(fn
              {:allow_nil?, _} -> true
              {:public?, _} -> true
              _ -> false
            end)

    # Based on Ash's lib/ash/resource/dsl.ex
    @req_belongs_to %Spark.Dsl.Entity{
      name: :req_belongs_to,
      describe: """
      Same as belongs_to but with allow_nil?: false and public?: true.
      """,
      examples: [
        """
        req_belongs_to :company, Company
        """
      ],
      no_depend_modules: [:destination],
      target: Ash.Resource.Relationships.BelongsTo,
      schema: @schema,
      transform: {Ash.Resource.Relationships.BelongsTo, :transform, []},
      args: [:name, :destination],
      auto_set_fields: [
        allow_nil?: false,
        public?: true
      ]
    }

    @req_prv_belongs_to %Spark.Dsl.Entity{
      name: :req_prv_belongs_to,
      describe: """
      Same as belongs_to but with allow_nil?: false and public?: false.
      """,
      examples: [
        """
        req_prv_belongs_to :company, Company
        """
      ],
      no_depend_modules: [:destination],
      target: Ash.Resource.Relationships.BelongsTo,
      schema: @schema,
      transform: {Ash.Resource.Relationships.BelongsTo, :transform, []},
      args: [:name, :destination],
      auto_set_fields: [
        allow_nil?: false,
        public?: false
      ]
    }

    @opt_belongs_to %Spark.Dsl.Entity{
      name: :opt_belongs_to,
      describe: """
      Same as belongs_to but with allow_nil?: true and public?: true.
      """,
      examples: [
        """
        opt_belongs_to :company, Company
        """
      ],
      no_depend_modules: [:destination],
      target: Ash.Resource.Relationships.BelongsTo,
      schema: @schema,
      transform: {Ash.Resource.Relationships.BelongsTo, :transform, []},
      args: [:name, :destination],
      auto_set_fields: [
        allow_nil?: true,
        public?: true
      ]
    }

    @opt_prv_belongs_to %Spark.Dsl.Entity{
      name: :opt_prv_belongs_to,
      describe: """
      Same as belongs_to but with allow_nil?: true and public?: false.
      """,
      examples: [
        """
        opt_prv_belongs_to :company, Company
        """
      ],
      no_depend_modules: [:destination],
      target: Ash.Resource.Relationships.BelongsTo,
      schema: @schema,
      transform: {Ash.Resource.Relationships.BelongsTo, :transform, []},
      args: [:name, :destination],
      auto_set_fields: [
        allow_nil?: true,
        public?: false
      ]
    }

    # def transform(attribute, allow_nil?) do
    #   %{attribute | allow_nil?: allow_nil?} |> Ash.Resource.Relationships.BelongsTo.transform()
    # end

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

    def patches() do
      [
        %Spark.Dsl.Patch.AddEntity{
          section_path: [:relationships],
          entity: @req_belongs_to
        },
        %Spark.Dsl.Patch.AddEntity{
          section_path: [:relationships],
          entity: @req_prv_belongs_to
        },
        %Spark.Dsl.Patch.AddEntity{
          section_path: [:relationships],
          entity: @opt_belongs_to
        },
        %Spark.Dsl.Patch.AddEntity{
          section_path: [:relationships],
          entity: @opt_prv_belongs_to
        }
      ]
    end
  end

  use Spark.Dsl.Extension, dsl_patches: ReqOptAttribute.patches() ++ ReqOptBelongsTo.patches()
end
