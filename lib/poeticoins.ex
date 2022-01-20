defmodule Poeticoins do
  defdelegate subscribe_to_trader(product), to: Poeticoins.Exchanges, as: :subscribe

  defdelegate unsubscribe_to_trader(product), to: Poeticoins.Exchanges, as: :unsubscribe
end
