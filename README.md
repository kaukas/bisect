# bisect

Find the interesting item in a list of items.

Ever needed to find a file that silently breaks your build? Ever wanted `git bisect` outside git? This tool performs binary search on a list of items. Also related to the concept of "shrinking" in property based testing.

Currently supports searching:

- For the single interesting item in a list of otherwise uninteresting items.
- For the first interesting item in a list that starts with uninteresting items and ends with interesting items.
- For the last interesting item in a list that starts with interesting items and ends with uninteresting items.
- Interactively: you get sublists to evaluate and decide if they are interesting.
- Automatically: you provide a command that is used to decide if a sublist is interesting.

Other kinds of searches to be implemented.

## Installation

```bash
git clone https://github.com/kaukas/bisect
cd bisect
shards build --release
```

## Usage

### Interactive

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
Consider this item:
1

Is it interesting? Enter + or -: -
Consider this item:
2

Is it interesting? Enter + or -: +
The interesting item:
2
At line 2
```

Note that line numbers are 1-based.

### Automatic

If there are arguments after `--` they are treated as a command that is to be automatically executed to verify if a list of items is interesting. The items to be verified are supplied as standard input. A 0 exit code means "not interesting" while any other exit code (e.g. a failing test suite) means it is interesting. Standard output is ignored while standard error is redirected to the bisect standard error.

```bash
cat items | ./bin/bisect -- <verifier commmand>
```

For example

```bash
$ echo -e "1\n2\n3" | ./bin/bisect -- bash -c "! grep 3"
The interesting item:
3
At line 3
```

Line numbers are 1-based, too.

### Mode "one"

This is the default mode. The algorithm looks for one interesting item in a list ("the needle in the haystack"). At each step a sublist is presented and a user interactively or a command automatically (see examples above) decide if the sublist contains the interesting item.

#### Trust

By default every subset is checked for presence of the interesting item. Say, if we are looking for 2 in `[1, 2, 3]` it will check items `[1, 2, 3]` (yes), then `[1, 2]` (yes), then `[1]` (no), then `[2]` (yes). However, if we are sure there is one interesting item then some of the checks are redundant. It would be enough to check `[1, 2]` (yes) and `[1]` (no), and `[2]` can be inferred. To skip the redundant checks pass `--trust`.

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
Consider this item:
1

Is it interesting? Enter + or -: -
The interesting item:
2
At line 2
```

### Mode "first"

`./bin/bisect --mode first` assumes that a list starts with uninteresting items and ends with interesting items, and looks for the first interesting item. At each step one item is presented. If the item is determined to be interesting then the algorithm looks at the part of the list preceding that item. Otherwise it looks at the part of the list after the item. This is equivalent to looking for the first failing commit with `git bisect` (albeit simplified because forks and merges are not taken into account).

#### Trust

By default the algorithm verifies that the first item is uninteresting and the last item is interesting before checking the items in the middle. If you are sure that the list always ends with an interesting item (e.g. the last commit is broken) pass `--trust`, and the right boundary check will be skipped.

### Mode "last"

The inverse of mode "first".

`./bin/bisect --mode last` assumes that a list starts with interesting items and ends with uninteresting items, and looks for the last interesting item.

#### Trust

By default the algorithm verifies that the first item is interesting and the last item is uninteresting before checking the items in the middle. If you are sure that the list always begins with an interesting item (e.g. the first commit is broken) pass `--trust`, and the left boundary check will be skipped.

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
