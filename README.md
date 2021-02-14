# bisect

Find the interesting item in a list of items.

Ever needed to find a file that silently breaks your build? Ever wanted `git bisect` outside git? This tool performs binary search on a list of items narrowing it until one item remains. Also related to the concept of "shrinking" in property based testing.

Currently supports searching for a single item interactively or automatically. Other kinds of searches to be implemented.

## Installation

```bash
git clone https://github.com/kaukas/bisect
cd bisect
shards build --release
```

## Usage

### Interactive Mode

```bash
./bin/bisect
```

For example

```
$ ./bin/bisect
Enter the list of items, one per line, and an empty line at the end:
1
2
3

Consider this list of items:
1
2
3

Are they interesting? Enter + or -: +
Consider this list of items:
1
2

Are they interesting? Enter + or -: +
Consider this list of items:
1

Are they interesting? Enter + or -: -
Consider this list of items:
2

Are they interesting? Enter + or -: +
The interesting item:
2
```

### Automatic Mode

If there are arguments after `--` they are treated as a command that is to be automatically executed to verify if a list of items is interesting. The items to be verified are supplied as standard input. A 0 exit code means "not interesting" while any other exit code (e.g. a failing test suite) means it is interesting. Standard output is ignored while standard error is redirected to the bisect standard error.

```bash
cat items | ./bin/bisect -- <verifier commmand>
```

For example

```bash
$ echo -e "1\n2\n3" | ./bin/bisect -- bash -c "! grep 3"
The interesting item:
3
```

### Trust

By default every subset is checked for presence of the interesting item. Say, if we are looking for 2 in `[1, 2, 3]` it will check items `[1, 2, 3]` (yes), then `[1, 2]` (yes), then `[1]` [no], then `[2]` (yes). However, if we are sure there is one interesting item then some of the checks are superfluous. It would be enough to check `[1, 2]` (yes), then `[1]` [no] and 2 would the answer. To skip the superfluous checks pass `--trust`.

```
$ ./bin/bisect --trust
Enter the list of items, one per line, and an empty line at the end:
1
2
3

Consider this list of items:
1
2

Are they interesting? Enter + or -: +
Consider this list of items:
1

Are they interesting? Enter + or -: -
The interesting item:
2
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
