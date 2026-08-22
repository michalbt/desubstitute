# User documentation

## Overview

`desubstitute` is a command-line tool for decrypting substitution ciphers using frequency analysis.

A *substitution cipher* is a type of cipher where each character of the original text (*plaintext*) is substituted by a different character of the alphabet. This mapping must be 1:1, i.e. a permutation on the alphabet, and only applies to characters in the alphabet, not spaces, numbers or punctuation (those stay unchanged). The result is called *ciphertext*.

To decrypt the cipher, `desubstitute` uses frequency analysis to guess the used substitution and get back the original plaintext. Specifically, average frequencies of single characters and *digrams* (pairs of consecutive characters) in the language of the original text need to be provided, along with a listing of the language's alphabet.

## Building the app

The app is written in [Haskell](TODO) uses [Cabal](TODO) as its dependency management and build system. Ensure you have [GHC](TODO) and Cabal installed.

Clone the repository:

```sh
git clone https://github.com/michalbt/desubstitute/ (TODO)
cd desubstitute
```

Build the app:

```sh
cabal build
```

## Running the app

### Example

```sh
$(cabal list-bin desubstitute.cabal) -a data/english/alphabet.txt -c data/english/characters.csv -d data/english/digrams.csv --print-substitution < data/english/ciphertext/alice_1.txt
```

In this example, `$(cabal list-bin desubstitute.cabal)` resolves to the path to the executable inside the build directory (`dist-newstyle/`). This does not automatically build the app!

### Options

All files are expected to be encoded in UTF-8.

- `-a` / `--alphabet`: Required. Path to a text file containing all characters in the alphabet of the language. Leading and trailing whitespace in the alphabet file is trimmed.
    - *Provided data: `data/<language>/alphabet.txt`*
- `-c` / `--char-frequencies`: Required. Path to a CSV file with 2 columns. The first column should contain all alphabet characters and the second column their respective frequencies in the language (as any number, does not need to be normalized).
    - The separator between the columns can be configured with the `--separator` option.
    - The frequencies are needed only for alphabet characters (not space or any other characters), however, any additional rows are ignored.
    - *Provided data: `data/<language>/characters.csv`*
- `-d` / `--digram-frequencies`: Required. Path to a CSV file with 2 columns. The first column should contain all digrams created from the alphabet characters (`XY` for `X` and `Y` alphabet characters) and the second column their respective frequencies in the language (as any number, does not need to be normalized).
    - The separator between the columns can be configured with the `--separator` option.
    - If the `--space-in-digrams` flag is set, this file should also contain all digrams with spaces, i.e. in the form `X ` and ` X` for each alphabet character `X`. Their frequencies should represent how often the character forms a start/end of a word, and could improve the output of the algorithm. When computing those values, all non-alphabet characters and also the start/end of text should be counted as a space, such that for example `a.` is counted as `a `. The two-space `  ` digram must also be present, however, its value is not used by the algorithm.
    - Any additional rows are ignored.
    - *Provided data: `data/<language>/digrams.csv`*
- `--separator`: Optional. A single character used as the column separator in the CSV files. Defaults to comma (`,`).
- `--space-in-digrams`: Optional flag. See above.
- `--print-substitution`: Optional flag. If set, the computed substitution will be printed along with the decrypted text. Each line in the substitution output is of the format `X -> Y`, where `X` is a plaintext character and `Y` its ciphertext counterpart. This means that the printed substitution is from plaintext to ciphertext, i.e. the one most likely used to encrypt the plaintext. The plaintext characters are ordered by their position in the alphabet file.

### Input

The app reads the ciphertext from standard input.

Encrypted ciphertexts can be found in `data/<language>/ciphertext/`. For convenience, the original plaintexts are also available in `data/<language>/plaintext/` and the substitution used for generating `data/<language>/ciphertext/something.txt` is always written to `data/<language>/ciphertext/something_solution.txt`, however, those files should not be passed to the app.

### Output

The app writes the decrypted plaintext to standard output. If `--print-substitution` is set, it also writes the computed substitution.

In case of an error, an error message is printed to standard error and the app is terminated.

## Data

TODO: add more data examples (Czech - with spaces)
TODO: add information about all provided data examples
