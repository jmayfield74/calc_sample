defmodule CalcSample.Calculations.Leaf do
  use Ash.Resource,
    domain: CalcSample.Calculations,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource, AshStateMachine]

  require Ash.Query

  postgres do
    table "leaves"
    repo CalcSample.Repo
  end

  attributes do
    uuid_primary_key :id
    create_timestamp :inserted_at
    update_timestamp :updated_at

    attribute :status, :atom do
      constraints one_of: [:pending, :current, :completed, :rejected]
      allow_nil? false
      default :pending
      public? true
    end
  end

  identities do
    identity :id, [:id]
  end

  relationships do
    belongs_to :middle, CalcSample.Calculations.Middle do
      allow_nil? false
      public? true
    end
  end

  state_machine do
    state_attribute(:status)
    initial_states([:pending])
    default_initial_state(:pending)

    transitions do
      transition(:start, from: [:completed, :pending], to: :current)
      transition(:complete, from: [:pending, :current], to: :completed)
      transition(:pend, from: [:current, :completed], to: :pending)
      transition(:reject, from: [:pending, :current], to: :rejected)
    end
  end

  actions do
    defaults [:read]

    update :start do
      change transition_state(:current)
    end

    update :complete do
      change transition_state(:completed)
    end

    update :pend do
      change transition_state(:pending)
    end

    update :reject do
      change transition_state(:rejected)
    end
  end

  graphql do
    type :leaf

    queries do
      get(:get_leaf, :read)
      list(:list_leaves, :read)
    end
  end
end
