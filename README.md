# RandomWords

[![Module Version](https://img.shields.io/hexpm/v/random_words.svg)](https://hex.pm/packages/random_words)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/random_words/)
[![Total Download](https://img.shields.io/hexpm/dt/random_words.svg)](https://hex.pm/packages/random_words)
[![License](https://img.shields.io/hexpm/l/random_words.svg)](https://hex.pm/packages/random_words)
[![Last Updated](https://img.shields.io/github/last-commit/apdunston/random_words.svg)](https://github.com/apdunston/random_words/commits/master)

Provides random words from a list of 5,000 most common American English words. Can break them down into parts-of-speech. Fun for party tricks, example strings, and random names.

Uses a GenServer to hold the list in-memory without relying on an application wide ETS table.

Based on the data from http://www.wordfrequency.info.

## Installation

Add `random_words` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:random_words, "~> 1.0.2"}
  ]
end
```

## Usage

```elixir
iex(1)> import RandomWords
RandomWords

iex(2)> :rand.seed(:exsplus, {101, 102, 103})
# Omitted

iex(3)> word()
"fist"

iex(4)> words(2)
["perform", "mix"]

iex(5)> verb()
"overlook"

iex(6)> adverb()
"always"

# Options-based call
iex(7)> word([part_of_speech: :noun])
"people"

# Conjunctive adverbs aren't included in the default list of adverbs.
# Mix them in with :any_adverb.
iex(8)> word([part_of_speech: :any_adverb])
"like"

# Numerals, determiners, and adjuncts aren't included in the default list of adjectives
# Mix them in with :any_adjective
iex(9)> word([part_of_speech: :any_adjective])
"French"
```

## Removed words

I removed "damn", "shit", and "fucking" because many people won't want to see them come up at random, and it was easier to remove them than to account for them. If there had been more of them, I would have considered "swears" as a part of speech.

I removed "n't" because I don't consider it a word at all.

## Contributing

There are a lot more options we could add, but I'm not sure which ones would be important to others. I'd also like to add random sentences and random paragraphs. That would be fun. You are welcome and encouraged to write up fun new ways to access and apply random words. I would love to see your pull requests.

Many thanks to  @bfcarpio Brendan Carpio for his contributions!

## License

Word list owned and provided by https://www.wordfrequency.info/. Their terms
are that this list cannot be reproduced without crediting them by URL.

All other material Copyright 2018 - 2020, Adrian P. Dunston provided under MIT license.
