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

  test "verify parts of speech" do
    parts_of_speech = ~w(adjective adjunct adverb conjunctive_adverb determiner
      interjection noun numeral preposition pronoun verb)a

    for part <- parts_of_speech do
      word = apply(RandomWords, part, [])
      verify_word(word)
      part = Atom.to_string(part) |> String.replace("_", " ")
      verify_part_of_speech(word, part)
    end
  end

  test "200 words a second" do
    time_200_via_word = measure(fn -> Enum.each(0..200, fn _ -> RandomWords.word() end) end)
    # IO.puts("200 words via word() in seconds: #{time_200_via_word}")
    assert time_200_via_word < 1

    time_200_via_words = measure(fn -> RandomWords.words(200) end)
    # IO.puts("200 words via words() in seconds: #{time_200_via_words}")
    assert time_200_via_words < 1
    assert time_200_via_words < time_200_via_word
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
      File.stream!("./priv/words.csv")
      |> Enum.filter(fn line ->
        String.contains?(line, ",#{word},")
      end)
      |> Enum.find(fn line ->
        String.contains?(line, ",#{part},")
      end)

    assert(found != nil, "#{found} did not contain #{part}.")
  end
end
