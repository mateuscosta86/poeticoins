defmodule Poeticoins do
  defdelegate subscribe_to_trader(product), to: Poeticoins.Exchanges, as: :subscribe

  defdelegate unsubscribe_to_trader(product), to: Poeticoins.Exchanges, as: :unsubscribe

  defdelegate get_last_trade(product), to: Poeticoins.Historical

  defdelegate get_last_trades(products), to: Poeticoins.Historical
end
