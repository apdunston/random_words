defmodule RandomWords do
  @moduledoc """
  Provide a random word from a list of 5,000 most common American English words.
  """
  NimbleCSV.define(MyParser, separator: ",", escape: "\"")

  def words(number, _opts \\ []) do
    Enum.map(1..number, fn _ -> word() end)
  end

  def word(opts) do
    opts
    |> wordlist()
    |> get_random()
  end

  def word do
    data() |> get_random()
  end

  @doc """
  Excludes numerals, determiners, and adjuncts. (See any_adjective/0)
  """
  def adjective, do: word(part_of_speech: "adjective")

  def adjunct, do: word(part_of_speech: "adjunct")

  @doc """
  Excludes conjunctive adverbs. (See any_adverb/0)
  """
  def adverb, do: word(part_of_speech: "adverb")

  def conjunctive_adverb, do: word(part_of_speech: "conjunctive_adverb")
  def determiner, do: word(part_of_speech: "determiner")
  def interjection, do: word(part_of_speech: "interjection")
  def noun, do: word(part_of_speech: "noun")
  def numeral, do: word(part_of_speech: "numeral")
  def preposition, do: word(part_of_speech: "preposition")
  def pronoun, do: word(part_of_speech: "pronoun")
  def verb, do: word(part_of_speech: "verb")

  @doc """
  Includes numerals, determiners, and adjuncts.
  """
  def any_adjective, do: word(part_of_speech: "any_adjective")

  @doc """
  Includes conjunctive adverbs.
  """
  def any_adverb, do: word(part_of_speech: "any_adverb")

  def wordlist, do: data()

  def wordlist(part_of_speech: "any_adjective") do
    speech = parts_of_speech()

    speech["adjective"] ++
      speech["determiner"] ++
      speech["numeral"] ++ speech["adjunct"]
  end

  def wordlist(part_of_speech: "any_adverb") do
    speech = parts_of_speech()
    speech["adverb"] ++ speech["conjunctive_adverb"]
  end

  def wordlist(part_of_speech: part), do: parts_of_speech()[part]

  # Private Functions #

  defp start_server do
    case RandomWords.WordServer in Process.registered() do
      false ->
        RandomWords.WordSupervisor.start_link()

      true ->
        nil
    end
  end

  defp get_random(list) do
    list
    |> Enum.random()
    |> case do
      map when is_map(map) -> map[:word]
      word -> word
    end
  end

  defp data do
    start_server()
    GenServer.call(RandomWords.WordServer, :words)
  end

  defp parts_of_speech do
    start_server()
    GenServer.call(RandomWords.WordServer, :parts_of_speech)
  end
end
