# Developer documentation

This documentation mainly describes the overall structure of the program. Individual types and functions are documented directly in the source code files.

## Technologies and dependencies

The app is written in Haskell and uses Cabal as its dependency management and build system. Detailed configuration can be found in the [`.cabal` file](../desubstitute.cabal).

In addition to the `base` and `containers` packages in the Haskell standard library, the app depends on `optparse-applicative` for CLI argument parsing.

## Algorithm

The algorithm is based on a [paper](https://www.researchgate.net/profile/Thomas-Jakobsen-6/publication/266714630_A_fast_method_for_cryptanalysis_of_substitution_ciphers/links/56ebe4fe08aefd0fc1c718ef/A-fast-method-for-cryptanalysis-of-substitution-ciphers.pdf) by Thomas Jakobsen (1995).

It first constructs an initial substitution based on the character frequencies - the most frequent ciphertext character will be mapped to the most frequent language character and so on. It also constructs two matrices of digram frequencies - `textMatrix` and `languageMatrix` - such that the following is true: `textMatrix[i][j]` is a frequency of a digram `c_ic_j` in the ciphertext decrypted by the current substitution and `languageMatrix[i][j]` is a frequency of the same digram `c_ic_j` in the language (`c_m` is the `m`-th character of the alphabet).

The algorithm is trying to minimize an evaluation function that describes how different these matrices are, i.e. how different the decrypted ciphertext looks from an average text in the language. This evaluation function is the sum of absolute differences of all matrix elements.

In each step, the algorithm tries to swap two characters in the substitution (this happens in a pre-defined order). This makes it neccessary to swap their respective rows and columns in the `textMatrix` as well. After that, the evaluation function is evaluated. If it has a lower value than before, the algorithm will continue with the updated substitution, otherwise, it will try swapping a different pair of characters. After attempting to swap all pairs of characters unsuccessfully, the algorithm will terminate.

## Code decomposition

TODO
