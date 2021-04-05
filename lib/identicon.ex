defmodule Identicon do
  def main(input) do
    # start off with the value passed in which basically initialized our string of calls witht he variable as the initial value
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    # 5x5 grid which is 300X300 px = 50*50px square

    # ignore the first variable since we want the index only
    Enum.map(grid, fn {_code, index} ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
    end)
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn {code, _index} ->
        rem(code, 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end

  # called with the image struct (it gets passed down from the pipe operator)
  def build_grid(%Identicon.Image{hex: hex} = image) do
    # save the result of this pipe operator into a variable
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      # &referenceFunction/arg#
      # will work on each row of the chuncked array to transform and return a new row that we will use in a NEW LIST
      |> Enum.map(&mirror_row/1)
      # takes a nested list and flattens it into a single list
      # we are doing this so we dont have to do a double loop into order to transform this
      |> List.flatten()
      # we use this function to create a list with a tuple of [{item, index}]
      |> Enum.with_index()

    # finally update the image struct to our new grid property and all prev props
    %Identicon.Image{image | grid: grid}
  end

  def mirror_row([first, second | _rest] = row) do
    # [145,46,200]  -> [145,46,200,46,200]
    row ++ [second, first]
    # joning lists with ++ operator
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
