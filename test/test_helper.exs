ExUnit.start()

defmodule TestHelper do
  use ExUnit.Case

  defmacro test_pos_helper(pos) do
    quote do
      test "give me a #{unquote(pos)}" do
        import RandomWords

        str_pos =
          unquote(pos)
          |> Kernel.to_string()
          |> String.replace("_", " ")

        word = unquote(pos)()
        verify_word(word)
        verify_part_of_speech(word, str_pos)
      end
    end
  end

  def measure(function) do
    function
    |> :timer.tc()
    |> elem(0)
    |> Kernel./(1_000_000)
  end

  def verify_word(word) do
    assert is_bitstring(word)
    assert word != ""
  end

  def verify_part_of_speech(word, part) do
    found =
      File.stream!("./priv/words.csv")
      |> Stream.filter(&String.contains?(&1, ",#{word},"))
      |> Enum.find(&String.contains?(&1, ",#{part},"))

    assert(found != nil, "#{found} did not contain #{part}.")
  end
end
