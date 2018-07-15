defmodule RandomWords.WordSupervisor do
  @moduledoc """
  Restart WordServer if there's a problem.
  """

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok, _opts \\ []) do
    children = [
      {RandomWords.WordServer, name: RandomWords.WordServer}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
