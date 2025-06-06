defmodule AshReqOpt do
  @attr_patches [
                  {:req, false, true},
                  {:req_prv, false, false},
                  {:opt, true, true},
                  {:opt_prv, true, false}
                ]
                |> Enum.map(fn {name, allow_nil?, public?} ->
                  # Based on Ash's lib/ash/resource/dsl.ex
                  entity = %Spark.Dsl.Entity{
                    name: name,
                    describe: """
                    Declares an attribute on the resource with allow_nil?: #{allow_nil?} and public?: #{public?}.
                    """,
                    examples: [
                      """
                      #{name} :email, :string do
                        default nil
                      end
                      """
                    ],
                    transform: {Ash.Resource.Attribute, :transform, []},
                    target: Ash.Resource.Attribute,
                    args: [:name, :type],
                    schema:
                      Ash.Resource.Attribute.attribute_schema()
                      |> Keyword.reject(fn
                        {:allow_nil?, _} -> true
                        {:public?, _} -> true
                        _ -> false
                      end),
                    auto_set_fields: [
                      allow_nil?: allow_nil?,
                      public?: public?
                    ]
                  }

                  %Spark.Dsl.Patch.AddEntity{
                    section_path: [:attributes],
                    entity: entity
                  }
                end)

  @belongs_to_patches [
                        {:req_belongs_to, false, true},
                        {:req_prv_belongs_to, false, false},
                        {:opt_belongs_to, true, true},
                        {:opt_prv_belongs_to, true, false}
                      ]
                      |> Enum.map(fn {name, allow_nil?, public?} ->
                        # Based on Ash's lib/ash/resource/dsl.ex
                        entity = %Spark.Dsl.Entity{
                          name: name,
                          describe: """
                          Same as belongs_to but with allow_nil?: #{allow_nil?} and public?: #{public?}.
                          """,
                          examples: [
                            """
                            #{name} :company, Company
                            """
                          ],
                          no_depend_modules: [:destination],
                          target: Ash.Resource.Relationships.BelongsTo,
                          schema:
                            Ash.Resource.Relationships.BelongsTo.opt_schema()
                            |> Keyword.reject(fn
                              {:allow_nil?, _} -> true
                              {:public?, _} -> true
                              _ -> false
                            end),
                          transform: {Ash.Resource.Relationships.BelongsTo, :transform, []},
                          args: [:name, :destination],
                          auto_set_fields: [
                            allow_nil?: allow_nil?,
                            public?: public?
                          ]
                        }

                        %Spark.Dsl.Patch.AddEntity{
                          section_path: [:relationships],
                          entity: entity
                        }
                      end)

  use Spark.Dsl.Extension, dsl_patches: @attr_patches ++ @belongs_to_patches
end
