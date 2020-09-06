defmodule RandomWords do
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

  @doc """
  Excludes numerals, determiners, and adjuncts. (See any_adjective/0)

  ## Examples

      # Seed random generation for examples
      iex> :rand.seed(:exsss, {101, 102, 103})
      iex> RandomWords.adjective()
      "troubled"
  """
  @spec adjective() :: String.t()
  def adjective, do: word(part_of_speech: :adjective)

  @doc """
  ## Examples

      # Seed random generation for examples
      iex> :rand.seed(:exsss, {101, 102, 103})
      iex> RandomWords.adjunct()
      "a"
  """
  @spec adjunct() :: String.t()
  def adjunct, do: word(part_of_speech: :adjunct)

  @doc """
  Excludes conjunctive adverbs. (See any_adverb/0)

  ## Examples


      # Seed random generation for examples
      iex> :rand.seed(:exsss, {101, 102, 103})
      iex> RandomWords.adverb()
      "briefly"
  """
  @spec adverb() :: String.t()
  def adverb, do: word(part_of_speech: :adverb)

  @doc """
  ## Examples

      # Seed random generation for examples
      iex> :rand.seed(:exsss, {101, 102, 103})
      iex> RandomWords.conjunctive_adverb()
      "now"
  """
  @spec conjunctive_adverb() :: String.t()
  def conjunctive_adverb, do: word(part_of_speech: :conjunctive_adverb)

  @doc """
  ## Examples

      # Seed random generation for examples
      iex> :rand.seed(:exsss, {101, 102, 103})
      iex> RandomWords.determiner()
      "enough"
  """
  @spec determiner() :: String.t()
  def determiner, do: word(part_of_speech: :determiner)

  @doc """
  ## Examples

      # Seed random generation for examples
      iex> :rand.seed(:exsss, {101, 102, 103})
      iex> RandomWords.interjection()
      "huh"
  """
  @spec interjection() :: String.t()
  def interjection, do: word(part_of_speech: :interjection)

  @doc """
  ## Examples

      
      # Seed random generation for examples
      iex> :rand.seed(:exsss, {101, 102, 103})
      iex> RandomWords.noun()
      "fraud"
  """
  @spec noun() :: String.t()
  def noun, do: word(part_of_speech: :noun)

  @doc """
  ## Examples

      # Seed random generation for examples
      iex> :rand.seed(:exsss, {101, 102, 103})
      iex> RandomWords.numeral()
      "first"
  """
  @spec numeral() :: String.t()
  def numeral, do: word(part_of_speech: :numeral)

  @doc """
  ## Examples

      # Seed random generation for examples
      iex> :rand.seed(:exsss, {101, 102, 103})
      iex> RandomWords.preposition()
      "under"
  """
  @spec preposition() :: String.t()
  def preposition, do: word(part_of_speech: :preposition)

  @doc """
  ## Examples

      # Seed random generation for examples
      iex> :rand.seed(:exsss, {101, 102, 103})
      iex> RandomWords.pronoun()
      "anybody"
  """
  @spec pronoun() :: String.t()
  def pronoun, do: word(part_of_speech: :pronoun)

  @doc """
  ## Examples

      # Seed random generation for examples
      iex> :rand.seed(:exsss, {101, 102, 103})
      iex> RandomWords.verb()
      "depict"
  """
  @spec verb() :: String.t()
  def verb, do: word(part_of_speech: :verb)

  @doc """
  Includes numerals, determiners, and adjuncts.

  ## Examples

      # Seed random generation for examples
      iex> :rand.seed(:exsss, {101, 102, 103})
      iex> RandomWords.any_adjective()
      "special"
  """
  @spec any_adjective() :: String.t()
  def any_adjective, do: word(part_of_speech: :any_adjective)

  @doc """
  Includes conjunctive adverbs.

  ## Examples

      # Seed random generation for examples
      iex> :rand.seed(:exsss, {101, 102, 103})
      iex> RandomWords.any_adverb()
      "freely"
  """
  @spec any_adverb() :: String.t()
  def any_adverb, do: word(part_of_speech: :any_adverb)

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

  @spec parts_of_speech() :: %{required(String.t()) => [String.t()]}
  defp parts_of_speech do
    start_server()
    GenServer.call(RandomWords.WordServer, :parts_of_speech)
  end
end
