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
      "n_views" => 2980
      },
      %{
        "type" => "QUESTION",
        "t_id" => "5cb1626e8588f22beb666a88",
        "creator_handle" => "random123",
        "title" => "जल का हमारे दैनिक जीवन में क्या महत्व है?",
        "n_views" => 29890
      },
      %{
        "type" => "ANSWER",
        "payload" => "https://dmeplmvppt9e3.cloudfront.net/tus/1abfa6fd-642d-466d-b26a-cd6b66348d63_1539330366.opus",
        "share_url" => "https://getvokal.com/question/1CRMG#Rahul.kumar",
        "t_id" => "5bc04ed3e2478442a0b58745",
        "logo" => "https://s3-ap-southeast-1.amazonaws.com/ok.talk.images/user_5b7f24034a4fe60a16b7df28/471114a4-b649-4103-b01e-1d10aa2f1ef9_voke_img_crop_2754487f-c2dc-479c-a75d-302c9d55c161.jpg",
        "creator_handle" => "random123",
        "title" => "क्या बकचोदी चलती रेहनी चाहिए ?",
        "n_views" => 29890
      }
    ]

    Enum.take_random(items, 1)
  end
end