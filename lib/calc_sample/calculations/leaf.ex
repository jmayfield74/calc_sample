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

  # code_interface do
  #   define :create

  #   define :read_by_id
  #   define :read_by_flow_ordered
  #   define :read_by_flow
  #   define :read_by_flow_and_phase

  #   define :follow
  #   define :start
  #   define :complete
  #   define :pend
  #   define :reject
  # end

  actions do
    defaults [:read]

    # create :create do
    #   accept [:flow_id, :phase_id, :follows]
    # end

    # read :read_by_id do
    #   argument :id, :uuid, allow_nil?: false
    #   filter expr(id == ^arg(:id))
    # end

    # read :read_by_flow_ordered do
    #   argument :flow_id, :uuid, allow_nil?: false
    #   manual PhaseManager.Projects.Actions.ReadFlowPhasesOrdered
    # end

    # # use read_by_flow_ordered action instead, or the linked list of flow_phases may come back un-ordered
    # read :read_by_flow do
    #   argument :flow_id, :uuid, allow_nil?: false
    #   filter expr(flow_id == ^arg(:flow_id))
    # end

    # read :read_by_flow_and_phase do
    #   argument :flow_id, :uuid, allow_nil?: false
    #   argument :phase_slug, :atom, allow_nil?: false

    #   get? true

    #   prepare fn query, _context ->
    #     phase = Phase.by_slug!(query.arguments.phase_slug)

    #     query
    #     |> Ash.Query.filter(phase_id == ^phase.id)
    #     |> Ash.Query.filter(flow_id == ^query.arguments.flow_id)
    #   end
    # end

    # update :follow do
    #   accept [:follows]
    # end

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

    # mutations do
    #   update :start_flow_phase, :start
    #   update :complete_flow_phase, :complete
    #   update :reject_flow_phase, :reject
    # end
  end
end
