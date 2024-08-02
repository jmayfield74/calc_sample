defmodule CalcSample.Repo do
  use AshPostgres.Repo,
    otp_app: :calc_sample

  def installed_extensions do
    ["ash-functions"]
  end
end
