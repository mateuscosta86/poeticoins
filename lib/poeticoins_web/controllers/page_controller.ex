defmodule PoeticoinsWeb.PageController do
  use PoeticoinsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
