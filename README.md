# RandomWords

Provides random words from a list of 5,000 most common American English words. Can break them down into parts-of-speech. Fun for party tricks, example strings, and random names.

Uses a GenServer to hold the list in-memory without relying on an application wide ETS table.

Based on the data from http://www.wordfrequency.info.

## Installation

Package can be installed
by adding `random_words` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:random_words, "~> 1.0.2"}
  ]
end
```

## Usage

```elixir
import RandomWords

word()
=> hilarious

words(2)
=> beefcake fancy

verb()
=> run

adverb()
=> greedily

# Options-based call
word([part_of_speech: :noun])
=> fourth

# Conjunctive adverbs aren't included in the default list of adverbs.
# Mix them in with :any_adverb.
word([part_of_speech: :any_adverb])
=> that

# Numerals, determiners, and adjuncts aren't included in the default list of adjectives
# Mix them in with :any_adjective
word([part_of_speech: :any_adjective])
=> fourth
```

## Removed words

I removed damn, shit, and fucking because many people won't want to see them come up at random, and it was easier to remove them than to account for them. If there had been more of them, I would have considered "swears" as a part of speech.

I removed n't because I don't consider it a word at all.

## Contributing

There are a lot more options we could add, but I'm not sure which ones would be important to others. I'd also like to add random sentences and random paragraphs. That would be fun. You are welcome and encouraged to write up fun new ways to access and apply random words. I would love to see your pull requests.