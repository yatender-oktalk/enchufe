defmodule Enchufe.Timer do
  use GenServer
  require Logger
  def start_link() do
    GenServer.start_link __MODULE__, %{}
  end
  ## SERVER ##

  # def init(_state) do
  #   Logger.warn "Enchufe timer server started"
  #   broadcast(300000000, "Started timer!")
  #   schedule_timer(1_000) # 1 sec timer
  #   {:ok, 300000000}
  # end

  def init(_state) do
    Logger.warn "Enchufe timer server started"
    EnchufeWeb.Endpoint.subscribe "timer:start", []
    {:ok, nil}
  end

  def handle_info(%{event: "start_timer"}, _time) do
    duration = 300
    schedule_timer 1_000
    broadcast duration, "Started timer!"
    {:noreply, duration}
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
    item = get_random_item()
    EnchufeWeb.Endpoint.broadcast! "timer:update", "new_time", %{
      response: response,
      time: Jason.encode!(item),
    }
  end

  def get_random_item() do
    items = [
      %{
        "type" => "QUESTION",
      "t_id" => "5bc04ed3e2478442a0b58745",
      "creator_handle" => "guest84nic",
      "title" => "दैनिक जीवन में pH का क्या महत्व है ?",
      "n_views" => 2980,
      "location" => %{
          "country" => "IN",
          "countryCode" => "IN",
          "region" => "Karnataka",
          "regionCode" => "",
          "city" => "Bengaluru",
          "postal" => "560076",
          "ip" => "106.51.21.204",
          "latitude" => 12.9833,
          "longitude" => 77.5833,
          "timezone" => ""
        }
      },
      %{
        "type" => "QUESTION",
        "t_id" => "5cb1626e8588f22beb666a88",
        "creator_handle" => "random123",
        "title" => "जल का हमारे दैनिक जीवन में क्या महत्व है?",
        "n_views" => 29890,
        "location" => %{
          "country" => "IN",
          "countryCode" => "IN",
          "region" => "National Capital Territory of Delhi",
          "regionCode" => "",
          "city" => "New Delhi",
          "postal" => "110043",
          "ip" => "139.167.250.100",
          "latitude" => 28.6014,
          "longitude" => 77.1989,
          "timezone" => ""
        }
      },
      %{
        "type" => "ANSWER",
        "t_id" => "5bc04ed3e2478442a0b58745",
        "creator_handle" => "random123",
        "title" => "क्या बकचोदी चलती रेहनी चाहिए ?",
        "n_views" => 29890,
        "location" => %{
          "country" => "IN",
        "countryCode" => "IN",
        "region" => "Bihar",
        "regionCode" => "",
        "city" => "",
        "postal" => "",
        "ip" => "106.207.33.43",
        "latitude" => 25.6,
        "longitude" => 85.1167,
        "timezone" => ""
      }
      }
    ]

    Enum.take_random(items, 1)
  end
end