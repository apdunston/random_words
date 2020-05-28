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
      %{rank: String.to_integer(rank), word: word, part: part}
    end)
    |> Enum.to_list()
    |> Enum.drop(1)
  end

  defp parts_of_speech(words) do
    words
    |> Enum.reduce(%{}, fn datum, acc ->
      part_name = datum[:part]

      list =
        case acc[part_name] do
          nil -> [datum[:word]]
          list -> [datum[:word] | list]
        end

      Map.put(acc, part_name, list)
    end)
  end
end
