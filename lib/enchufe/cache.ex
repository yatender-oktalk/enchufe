defmodule Enchufe.Cache do
  require Exredis

  def run_redis_query(query_opts) do
    with {:ok, client} <- Exredis.start_link() do
      res = client |> Exredis.query(query_opts)
      client |> Exredis.stop()
      res
    else
      _ ->
        :undefined
    end
  rescue
    _ ->
      :undefined
  end

  def add_by_key(key, values, expiry) do
    run_redis_query(["set", key, values, "ex", expiry])
  end

  def lpop(queue_name) do
    case resp = run_redis_query(["lpop", queue_name]) do
      :undefined -> :undefined
      _ -> Jason.decode!(resp)
    end
  end

  def lpush(queue_name, data) do
    run_redis_query(["lpush", queue_name, Jason.encode!(data)])
  end

  def expire_key(key, value) do
    run_redis_query(["expire", key, value])
  end

  def monitor() do
    run_redis_query(["monitor"])
  end
end
