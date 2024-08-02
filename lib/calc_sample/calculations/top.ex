defmodule CalcSample.Calculations.Top do
  use Ash.Resource,
    domain: CalcSample.Calculations,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  postgres do
    table "top"
    repo CalcSample.Repo
  end

  attributes do
    uuid_primary_key :id do
      writable? true
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at

    attribute :name, :string do
      allow_nil? false
      public? true
    end
  end

  relationships do
    has_many :middles, CalcSample.Calculations.Middle do
      public? true
    end
  end

  calculations do
    # foo
    calculate :status,
              :string,
              expr(
                if exists(middles, rejected != true) do
                  "active"
                else
                  "archived"
                end
              ),
              filterable?: true,
              public?: true
  end

  code_interface do
    define :create
  end

  actions do
    defaults [:read]

    create :create do
      accept [:id, :name]
    end
  end

  graphql do
    type :top

    queries do
      get(:get_top, :read)
      list(:list_tops, :read)
    end
  end
end
