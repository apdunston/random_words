defmodule RandomWordsTest do
  use ExUnit.Case
  doctest RandomWords
  import TestHelper

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

  # See `TestHelper` module for the definitions
  test_pos_helper(:adjective)
  test_pos_helper(:adverb)
  test_pos_helper(:conjunctive_adverb)
  test_pos_helper(:determiner)
  test_pos_helper(:interjection)
  test_pos_helper(:noun)
  test_pos_helper(:numeral)
  test_pos_helper(:preposition)
  test_pos_helper(:pronoun)
  test_pos_helper(:verb)

  test "200 words a second" do
    time_200_via_word = measure(fn -> Enum.each(0..200, fn _ -> RandomWords.word() end) end)
    IO.puts("200 words via word() in seconds: #{time_200_via_word}")
    assert time_200_via_word < 1

    time_200_via_words = measure(fn -> RandomWords.words(200) end)
    IO.puts("200 words via words() in seconds: #{time_200_via_words}")
    assert time_200_via_words < 1
    assert time_200_via_words < time_200_via_word
  end
end
