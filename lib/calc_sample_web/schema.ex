defmodule CalcSampleWeb.Schema do
  use Absinthe.Schema

  use AshGraphql,
    domains: [
      CalcSample.Calculations
    ]

  query do
  end

  mutation do
  end
end
