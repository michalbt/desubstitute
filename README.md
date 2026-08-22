# desubstitute

A command-line tool to decrypt substitution ciphers using frequency analysis.

## Specification (in Czech)

The source document for the specification can be found [here](spec/).

## User documentation

The user documentation can be found [here](docs/user.md).

## Data Sources

- `data/english/characters.csv`, `data/english/digrams.csv`
  - Original source: [English Letter Frequencies - practicalcryptography.com](http://practicalcryptography.com/cryptanalysis/letter-frequencies-various-languages/english-letter-frequencies/)
  - Modifications: converted to CSV format
- `data/english/plaintext/alice_in_wonderland_start.txt`
  - Downloaded from: [GitHub](https://gist.github.com/phillipj/4944029)
  - Original source: Lewis Carroll - Alice's Adventures in Wonderland

## Project information

This project was created as a semester project for the *Non-procedural Programming* course at the [Faculty of Mathematics and Physics, Charles University, Prague](https://www.mff.cuni.cz/) in the summer semester of the 2025/2026 academic year.
