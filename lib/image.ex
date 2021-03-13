# Struct = is a map that is used to stroe data in an elixir app
# just like maps, 2 advantages 1- default values 2- compile time checking of properties

defmodule Identicon.Image do
  # defines struct and has a single k:v of nil
  defstruct hex: nil, color: nil
end
