defmodule RandomWordsTest do
  use ExUnit.Case
  doctest RandomWords

  test "greets the world" do
    assert RandomWords.hello() == :world
  end
end
