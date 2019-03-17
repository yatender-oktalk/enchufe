defmodule Enchufe.Timer do
  use GenServer
  require Logger
  def start_link() do
    GenServer.start_link __MODULE__, %{}
  end
  ## SERVER ##

  def init(_state) do
    Logger.warn "Enchufe timer server started"
    broadcast(30, "Started timer!")
    schedule_timer(1_000) # 1 sec timer
    {:ok, 30}
  end
  def handle_info(:update, 0) do
    broadcast 0, "TIMEEEE"
    {:noreply, 0}
  end
  def handle_info(:update, time) do
    leftover = time - 1
    broadcast leftover, "tick tock... tick tock"
    schedule_timer(1_000)
    {:noreply, leftover}
  end
  defp schedule_timer(interval) do
    Process.send_after self(), :update, interval
  end
  defp broadcast(time, response) do
    EnchufeWeb.Endpoint.broadcast! "timer:update", "new_time", %{
      response: response,
      time: time,
    }
  end
end