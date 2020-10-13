defmodule RandomWords do
  import RandomWords.Helpers

  @moduledoc """
  Provide a random word from a list of 5,000 most common American English words.


  Word list owned and provided by https://www.wordfrequency.info/. Their terms are that this list cannot be reproduced without crediting them by URL.
  """
  NimbleCSV.define(MyParser, separator: ",", escape: "\"")

  @typep word_data :: %{
           part: String.t(),
           rank: non_neg_integer(),
           word: String.t()
         }

  @type part_of_speech ::
          :adjective
          | :adjunct
          | :adverb
          | :conjunctive_adverb
          | :determiner
          | :interjection
          | :noun
          | :numeral
          | :preposition
          | :pronoun
          | :verb

  @type part_of_speech_options :: :any | :any_adverb | :any_adjective | part_of_speech

  @type opts :: [
          part_of_speech: part_of_speech_options
        ]

  @doc """
  ## Examples

      # Seed random generation for examples
      iex> :rand.seed(:exsss, {101, 102, 103})
      iex> RandomWords.words(3)
      ["green", "scandal", "resistance"]
  """
  @spec words(non_neg_integer(), opts()) :: list(String.t())
  def words(count, opts \\ [part_of_speech: :any]) do
    opts
    |> wordlist()
    |> Enum.take_random(count)
  end

  @doc """
  ## Examples

      # Seed random generation for examples
      iex> :rand.seed(:exsss, {101, 102, 103})
      iex> RandomWords.word()
      "straight"
  """
  @spec word(opts) :: String.t()
  def word(opts \\ [part_of_speech: :any]), do: wordlist(opts) |> Enum.random()

  pos_helper(:adjective)
  pos_helper(:adjunct)
  pos_helper(:adverb)
  pos_helper(:conjunctive_adverb)
  pos_helper(:determiner)
  pos_helper(:interjection)
  pos_helper(:noun)
  pos_helper(:numeral)
  pos_helper(:preposition)
  pos_helper(:pronoun)
  pos_helper(:verb)

  @doc """
  Returns all the words available in any / the specified category.

  ## Examples

      iex> RandomWords.wordlist() |> length()
      4995
      iex> RandomWords.wordlist(part_of_speech: :verb) |> length()
      1001
  """
  @spec wordlist(opts) :: list(String.t())
  def wordlist(opts \\ [part_of_speech: :any])

  def wordlist(part_of_speech: :any) do
    data() |> Enum.map(&Map.fetch!(&1, :word))
  end

  def wordlist(part_of_speech: :any_adjective) do
    words_for_parts_of_speech([:adjective, :determiner, :numberal, :adjunct])
  end

  def wordlist(part_of_speech: :any_adverb) do
    words_for_parts_of_speech([:adverb, :conjunctive_adverb])
  end

  def wordlist(part_of_speech: part) do
    parts_of_speech()
    |> Map.fetch!(part)
  end

  # Private Functions #

  defp start_server do
    case RandomWords.WordServer in Process.registered() do
      false ->
        RandomWords.WordSupervisor.start_link()

      true ->
        nil
    end
  end

  @spec words_for_parts_of_speech(list(part_of_speech())) :: list(String.t())
  defp words_for_parts_of_speech(parts) do
    parts_of_speech()
    |> Map.take(parts)
    |> Map.values()
    |> List.flatten()
  end

  @spec data() :: list(word_data())
  defp data do
    start_server()
    GenServer.call(RandomWords.WordServer, :words)
  end

  @spec parts_of_speech() :: %{required(part_of_speech()) => [String.t()]}
  defp parts_of_speech do
    start_server()
    GenServer.call(RandomWords.WordServer, :parts_of_speech)
  end
end
