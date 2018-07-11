defmodule RandomWords do
  @moduledoc """
  Documentation for RandomWords.
  """

  @doc """
  Hello world.

  ## Examples

      iex> RandomWords.hello
      :world

  """
  NimbleCSV.define(MyParser, separator: ",", escape: "\"")

  def hello do
    IO.inspect parts_of_speech()
  end

  def words(number, _opts \\ []) do
    Enum.map(1..number, fn (_) -> word() end)
  end

  def word([part_of_speech: :adverb]) do
    parts_of_speech()
    |> Map.get("adverb")
    |> get_random
  end

  def word([part_of_speech: :adjective]) do
    speech = parts_of_speech()
    words = speech["adjective"] ++ speech["determiner"]
    get_random(words)
  end

  def word([part_of_speech: :verb]) do
    parts_of_speech()
    |> Map.get("verb")
    |> get_random
  end

  def word([part_of_speech: :noun]) do
    parts_of_speech()
    |> Map.get("noun")
    |> get_random
  end

  def word([part_of_speech: :adjunct]) do
    parts_of_speech()
    |> Map.get("adjunct")
    |> get_random
  end

  def word do
    data() |> get_random()
  end

  def adverb, do: word(part_of_speech: :adverb)
  def verb, do: word(part_of_speech: :verb)
  def adjective, do: word(part_of_speech: :adjective)
  def noun, do: word(part_of_speech: :noun)
  def adjunct, do: word(part_of_speech: :adjunct)

  # Private Functions #

  defp get_random(list) do
    list
    |> Enum.random()
    |> case do
      map when is_map(map) -> map[:word]
      word -> word
    end
  end

  defp data do
    "data/words.csv"
    |> File.stream!
    |> MyParser.parse_stream
    |> Stream.map(fn [rank, word, part, _frequency, _dispersion, _blank] ->
      %{rank: String.to_integer(rank), word: word, part: part}
    end)
    |> Enum.to_list
    |> Enum.drop(1)
  end

  defp parts_of_speech do
    data()
    |> Enum.reduce(%{}, fn (datum, acc) ->
      part_name = datum[:part]
      list = case acc[part_name] do
        nil -> [datum[:word]]
        list -> [datum[:word]|list]
      end

      Map.put(acc, part_name, list)
    end)
  end
end
