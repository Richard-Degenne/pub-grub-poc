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

Solves dependencies based on a given manifest repository. If a lockfile already
exists, locking will try to reuse locked version as much as possible.

Feel free to play with the files in the [`data`](data/) folder to try out
different scenarios.

### Updating

    bundle exec bin/update

Updating is like locking, with the exception that locked versions are ignored.
