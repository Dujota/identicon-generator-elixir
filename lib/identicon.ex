defmodule Identicon do
  def main(input) do
    # start off with the value passed in which basically initialized our string of calls witht he variable as the initial value
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  def build_grid(image) do
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _rest]} = image) do
    # pattern match for the struct and the key which happens to be a list

    # we do not modify exisiting data, alays create a new record with new properties + old struct data
    %Identicon.Image{image | color: {r, g, b}}
  end

  def hash_input(input) do
    # produces a string of #s <<114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65>>
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end

  # figure out a way to store raw(model level data) that powers our app, we use the --> struct : it is a map that is used to store data in an elixir app
  # just like maps but have 2 advantages
  # 1- can be assigned default values
  # 2 - some compile time checking of properties
end
