defmodule RandomWords do
  @moduledoc """
  Provide a random word from a list of 5,000 most common American English words. Provide options for
  multiple words at once and words of a particular part-of-speech.

  Word list owned and provided by https://www.wordfrequency.info/. Their terms are that this list
  cannot be reproduced without crediting them by URL.
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
      iex> :rand.seed(:exs1024, {123, 123534, 345345})
      iex> RandomWords.words(3)
      ["gene", "peasant", "candidate"]
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
      iex> :rand.seed(:exs1024, {123, 123534, 345345})
      iex> RandomWords.word()
      "include"
  """
  @spec word(opts) :: String.t()
  def word(opts \\ [part_of_speech: :any]), do: wordlist(opts) |> Enum.random()

  @doc """
  Returns a word of type adjective. Note: this excludes determiners, numerals, and adjuncts.
  While technically part of the adjective family, they are specific cases. See wordlist/1
  for `any_adjective`.
  """
  @spec adjective() :: String.t()
  def adjective, do: word(part_of_speech: :adjective)

  @doc "Returns a word of type adjunct"
  @spec adjunct() :: String.t()
  def adjunct, do: word(part_of_speech: :adjunct)

  @doc """
  Returns a word of type adverb. Note: this excludes conjunctive_adverbs.
  While technically part of the adverb family, they are specific cases. See wordlist/1
  for `any_adverb`.
  """
  @spec adverb() :: String.t()
  def adverb, do: word(part_of_speech: :adverb)

  @doc "Returns a word of type conjunctive_adverb"
  @spec conjunctive_adverb() :: String.t()
  def conjunctive_adverb, do: word(part_of_speech: :conjunctive_adverb)

  @doc "Returns a word of type determiner"
  @spec determiner() :: String.t()
  def determiner, do: word(part_of_speech: :determiner)

  @doc "Returns a word of type interjection"
  @spec interjection() :: String.t()
  def interjection, do: word(part_of_speech: :interjection)

  @doc "Returns a word of type noun"
  @spec noun() :: String.t()
  def noun, do: word(part_of_speech: :noun)

  @doc "Returns a word of type numeral"
  @spec numeral() :: String.t()
  def numeral, do: word(part_of_speech: :numeral)

  @doc "Returns a word of type preposition"
  @spec preposition() :: String.t()
  def preposition, do: word(part_of_speech: :preposition)

  @doc "Returns a word of type pronoun"
  @spec pronoun() :: String.t()
  def pronoun, do: word(part_of_speech: :pronoun)

  @doc "Returns a word of type verb"
  @spec verb() :: String.t()
  def verb, do: word(part_of_speech: :verb)

  @doc """
  Returns all the words available in any / the specified category.

  Note that the `:any_adjective` part-of-speech option includes the
  determiners, numerals, and adjuncts that are part of the broader
  adjective family.

  Note that the `:any_adverb` part-of-speech option includes the
  conjunctive adverbs that are part of the broader adverb family.

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
    words_for_parts_of_speech([:adjective, :determiner, :numeral, :adjunct])
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
