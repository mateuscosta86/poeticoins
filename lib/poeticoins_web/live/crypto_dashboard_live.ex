defmodule PoeticoinsWeb.CryptoDashboardLive do
  use PoeticoinsWeb, :live_view

  alias Poeticoins.Products.Product
  import PoeticoinsWeb.ProductHelpers

  def mount(_params, _session, socket) do
    socket = assign(socket, trades: %{}, products: [], filter_products: & &1)
    {:ok, socket}
  end

  def handle_info({:new_trade, trade}, socket) do
    socket =
      update(socket, :trades, fn trades ->
        Map.put(trades, trade.product, trade)
      end)

    {:noreply, socket}
  end

  def handle_event("add-product", %{"product_id" => product_id}, socket) do
    [exchange_name, currency_pair] = String.split(product_id, ":")
    product = Product.new(exchange_name, currency_pair)
    socket = maybe_add_product(socket, product)
    {:noreply, socket}
  end

  def handle_event("add-product", _, socket) do
    {:noreply, socket}
  end

  def handle_event("filter-products", %{"search" => search}, socket) do
    socket =
      assign(socket, :filter_products, fn product ->
        String.downcase(product.exchange_name) =~ String.downcase(search) or
          String.downcase(product.currency_pair) =~ String.downcase(search)
      end)

    {:noreply, socket}
  end

  defp maybe_add_product(socket, product) do
    if product not in socket.assigns.products do
      socket
      |> add_product(product)
      |> put_flash(
        :info,
        "#{product.exchange_name} - #{product.currency_pair} added successfully."
      )
    else
      IO.inspect(product)

      socket
      |> put_flash(
        :error,
        "#{product.exchange_name} - #{product.currency_pair} already added."
      )
    end
  end

  defp add_product(socket, product) do
    Poeticoins.subscribe_to_trades(product)

    socket
    |> update(:products, &(&1 ++ [product]))
    |> update(:trades, fn trades ->
      trade = Poeticoins.get_last_trade(product)
      Map.put(trades, product, trade)
    end)
  end

  defp grouped_products_by_exchange_name do
    Poeticoins.available_products()
    |> Enum.group_by(& &1.exchange_name)
  end
end
