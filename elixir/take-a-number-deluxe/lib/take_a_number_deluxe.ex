defmodule TakeANumberDeluxe do
  alias TakeANumberDeluxe.State
  use GenServer

  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg)
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    GenServer.call(machine, :report_state)
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, :queue_new_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve_next_queued_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.cast(machine, :reset_state)
  end

  # Server callbacks

  @impl GenServer
  @spec init(keyword()) :: {:ok, pid()} | {:stop, atom()} | {:error, atom()}
  def init(state) do
    min_number = state[:min_number]
    max_number = state[:max_number]
    timeout = state[:auto_shutdown_timeout] || :infinity
    case State.new(min_number, max_number, timeout) do
      {:ok, new_state} -> {:ok, new_state, timeout}
      {:error, reason} -> {:stop, reason}
    end
  end

  @impl GenServer
  @spec handle_call(atom(), pid(), %State{}) :: %State{}
  def handle_call(:report_state, _caller, state) do
    {:reply, state, state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  @spec handle_call(atom(), pid(), %State{}) :: %State{}
  def handle_call(:queue_new_number, _caller, state) do
    case State.queue_new_number(state) do
      {:ok, new_num, new_state} ->
        {:reply, {:ok, new_num}, new_state, state.auto_shutdown_timeout}
      {:error, reason} ->
        {:reply, {:error, reason}, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  @spec handle_call({atom(), integer() | nil}, pid(), %State{}) :: %State{}
  def handle_call({:serve_next_queued_number, pri_num}, _caller, state) do
    case State.serve_next_queued_number(state, pri_num) do
      {:ok, new_num, new_state} ->
        {:reply, {:ok, new_num}, new_state, state.auto_shutdown_timeout}
      {:error, reason} ->
        {:reply, {:error, reason}, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  @spec handle_cast(atom(),  %State{}) :: %State{}
  def handle_cast(:reset_state, state) do
    {:ok, state, timeout} =
      init(min_number: state.min_number,
           max_number: state.max_number,
           auto_shutdown_timeout: state.auto_shutdown_timeout)
    {:noreply, state, timeout}
  end

  @impl GenServer
  @spec handle_info(atom(),  any()) :: {atom(), atom(), %{}}
  def handle_info(:timeout, _) do
    {:stop, :normal, []}
  end

  @impl GenServer
  def handle_info(_, state) do
    {:noreply, state, state.auto_shutdown_timeout}
  end
end
