# PubGrub POC

Simplistic dependency solver using PubGrub

## Installation

```sh
git clone https://github.com/Richard-Degenne/pub-grub-poc
cd pub-grub-poc
bundle install
```

## Usage

### Locking

    bundle exec bin/lock

Solves dependencies based on a given manifest and repository.

Feel free to play with the files in the [`data`](data/) folder to try out
different scenarios.
