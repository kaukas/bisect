# bisect

Find the interesting item in a list of items.

Ever wanted `git bisect` outside git? This tool performs binary search on a list of items narrowing it until one item remains. Also related to "shirinking" in property based testing.

Currently supports searching for a single item interactively. Automatic mode and other kinds of searches to be implemented.

## Installation

```bash
git clone https://github.com/kaukas/bisect
cd bisect
shards build --release
```

## Usage

```bash
./bin/bisect
```

## Development

Install with

```bash
shards install
```

Run tests with

```bash
crystal spec
```

## Contributing

1. Fork it (<https://github.com/kaukas/bisect/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Linas](https://github.com/kaukas) - creator and maintainer
