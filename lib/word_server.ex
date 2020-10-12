defmodule RandomWords.WordServer do
  @moduledoc """
  Holds word data in memory.
  """
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(_) do
    words = read_from_csv()
    parts_of_speech = parts_of_speech(words)
    {:ok, {words, parts_of_speech}}
  end

  def handle_call(:words, _from, {words, _parts_of_speech} = state) do
    {:reply, words, state}
  end

  def handle_call(:parts_of_speech, _from, {_words, parts_of_speech} = state) do
    {:reply, parts_of_speech, state}
  end

  # Private Functions #

  defp read_from_csv do
    words_file = Path.join(:code.priv_dir(:random_words), "words.csv")

    words_file
    |> File.stream!()
    |> MyParser.parse_stream()
    |> Stream.map(fn [rank, word, part, _frequency, _dispersion, _blank] ->
      part = part |> String.replace(" ", "_") |> String.to_atom()
      %{rank: String.to_integer(rank), word: word, part: part}
    end)
    |> Stream.drop(1)
    |> Enum.to_list()
  end

  @spec parts_of_speech(any()) :: %{required(String.t()) => [String.t()]}
  defp parts_of_speech(words) do
    Enum.group_by(words, &Map.fetch!(&1, :part), &Map.fetch!(&1, :word))
  end
end
