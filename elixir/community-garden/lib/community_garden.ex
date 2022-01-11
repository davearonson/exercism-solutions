# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  @enforce_keys [:max, :plots]
  defstruct [max: 0, plots: []]

  def start(opts \\ []) do
    Agent.start(fn -> %__MODULE__{max: 0, plots: []} end, opts)
  end

  def list_registrations(pid) do
    Agent.get(pid, fn(arg) -> arg end).plots
  end

  def register(pid, register_to) do
    state = Agent.get(pid, fn(arg) -> arg end)
    new_max = state.max + 1
    plot = %Plot{plot_id: new_max, registered_to: register_to}
    Agent.update(pid,
                 fn(state) ->
                   %__MODULE__{state | plots: [plot|state.plots], max: new_max}
                 end)
    plot
  end

  def release(pid, plot_id) do
    plots = list_registrations(pid)
    plot = Enum.find(plots, fn(p) -> p.plot_id == plot_id end)
    if plot do
      # do NOT update max; we don't reuse plot numbers!
      Agent.update(pid,
                   fn(state) -> %__MODULE__{state|plots: plots -- [plot]} end)
      :ok
    else
      :error
    end
  end

  def get_registration(pid, plot_id) do
    plot = Enum.find(list_registrations(pid),
                     fn(p) -> p.plot_id == plot_id end)
    if plot, do: plot, else: {:not_found, "plot is unregistered"}
  end
end
