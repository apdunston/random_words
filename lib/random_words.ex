defmodule RandomWords do
  @moduledoc """
  Documentation for RandomWords.
  """

  @doc """
  Hello world.

  ## Examples
  """
  NimbleCSV.define(MyParser, separator: ",", escape: "\"")

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
