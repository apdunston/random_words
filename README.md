# RandomWords

A random word generator based on the data from http://www.wordfrequency.info.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `random_words` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:random_words, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/random_words](https://hexdocs.pm/random_words).

## Usage

```
import RandomWords

word()
=> hilarious

words(2)
=> beefcake fancy

verb()
=> run

adverb()
=> greedily

# Specify the size of the word list (top 100 words)
word(list_size: 100)
=> a

words(2, list_size: 100)
=> an the

# top 100 verbs
verbs(2, list_size: 100)
=> swim is

word(part_of_speech: :verb)
=> dance

swear()
=> damn

# include_swears is false by default
word(include_swears: true)
=> funny

word(only_swears: true)
=> damn

word(include_swears: false, only_swears: true)
> ERROR; cannot include_swears: false and only_swears: true

word(min_letters: 2, max_letters: 3)
=> and

# > 6 letters
word(size: :long)
=> experience

# 4-6 letters
word(size: :medium)
=> funny

# 1-3 letters
word(size: :short)
=> run

word(starts_with: "ex")
=> expect

word(starts_with: "vvvvv")
> nil

word(ends_with: "an")
=> ran

word(contains: "fu")
=> beautiful
```

## Removed words

I removed damn, shit, and fucking because they are considered swears, and it was easier to remove them than to account for them. If there had been more of them, I would have considered "swears" as a part of speech.

I removed n't because I don't consider it a word at all.

## Todo

* Remember that not is an adverb and you need to remove n't from the list.
* Remember to note the swears
* Create a named process that holds the data in-memory with init/0 and kill/0 functions