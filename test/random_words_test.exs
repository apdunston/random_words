defmodule RandomWordsTest do
  use ExUnit.Case
  doctest RandomWords

  test "give me a word" do
    word = RandomWords.word()
    verify_word(word)
  end

  test "give me five words" do
    words = RandomWords.words(5)
    assert is_list(words)
    assert length(words) == 5
    Enum.each(words, &verify_word/1)
  end

  test "give me a verb" do
    verb = RandomWords.verb()
    verify_word(verb)
    verify_part_of_speech(verb, "verb")
  end

  test "give me a noun" do
    noun = RandomWords.noun()
    verify_word(noun)
    verify_part_of_speech(noun, "noun")
  end

  test "200 words a second" do
    assert measure(fn -> Enum.each(0..200, fn _ -> RandomWords.word() end) end) < 1
  end

  defp measure(function) do
    function
    |> :timer.tc()
    |> elem(0)
    |> Kernel./(1_000_000)
  end

  defp verify_word(word) do
    assert is_bitstring(word)
    assert word != ""
  end

  defp verify_part_of_speech(word, part) do
    found =
      File.stream!("./data/words.csv")
      |> Enum.filter(fn line ->
        String.contains?(line, ",#{word},")
      end)
      |> Enum.find(fn line ->
        String.contains?(line, ",#{part},")
      end)

    assert(found != nil, "#{found} did not contain #{part}.")
  end
end
