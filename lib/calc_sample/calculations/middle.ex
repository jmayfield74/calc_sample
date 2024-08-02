defmodule CalcSample.Calculations.Middle do
  use Ash.Resource,
    domain: CalcSample.Calculations,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  postgres do
    table "middle"
    repo CalcSample.Repo
  end

  attributes do
    uuid_primary_key :id do
      writable? true
    end

    create_timestamp :inserted_at do
      public? true
    end

    update_timestamp :updated_at

    attribute :name, :string do
      allow_nil? false
      public? true
    end
  end

  aggregates do
    exists :rejected, :leaves do
      filter expr(status == :rejected)
      public? true
      filterable? true
    end
  end

  relationships do
    has_many :leaves, CalcSample.Calculations.Leaf do
      public? true
    end

    belongs_to :top, CalcSample.Calculations.Top do
      public? true
    end
  end

  code_interface do
    define :create
  end

  actions do
    defaults [:read]

    create :create do
      accept [:id, :name]
    end

    update :update do
      accept [:name]
    end
  end

  graphql do
    type :middle

    queries do
      get(:get_middle, :read)
      list(:list_middle, :read)
    end

    mutations do
      update :update_middle, :update
    end
  end
end
