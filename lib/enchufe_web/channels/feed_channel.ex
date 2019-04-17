defmodule EnchufeWeb.FeedChannel do
  use Phoenix.Channel

  def join("feed:update", _msg, socket) do
    {:ok, socket}
  end

  def handle_in("new_item", msg, socket) do
    IO.inspect socket
    push socket, "new_item", msg
    {:noreply, socket}
  end
end