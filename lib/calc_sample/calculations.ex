defmodule CalcSample.Calculations do
  use Ash.Domain, extensions: [AshGraphql.Domain]

  resources do
    resource CalcSample.Calculations.Top
    resource CalcSample.Calculations.Middle
    resource CalcSample.Calculations.Leaf
  end

  graphql do
    authorize? false
  end
end
