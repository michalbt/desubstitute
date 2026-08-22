#!/usr/bin/env python3

"""
A tool to encrypt a given plaintext by a random substitution. Used for generating example ciphertexts.

Usage:
    tools/substitute.py path/to/plaintext.txt path/to/alphabet.txt

Outputs the ciphertext on stdout and the used substitution on stderr.
"""

import random
import sys

def random_substitution(alphabet: str) -> dict[str, str]:
    alphabet_copy = list(alphabet)
    random.shuffle(alphabet_copy)
    return {k: v for k, v in zip(alphabet, alphabet_copy)}

def substitute_text(text: str, substitution: dict[str, str]) -> str:
    new_text = ""
    for char in text:
        char, was_upper = (char.lower(), True) if char.isupper() else (char, False)
        if char in substitution:
            new_char = substitution[char]
        else:
            new_char = char
        if was_upper:
            new_char = new_char.upper()
        new_text += new_char
    return new_text

def main():
    plaintext_file_path = sys.argv[1]
    alphabet_file_path = sys.argv[2]
    with open(plaintext_file_path, "r", encoding="utf-8") as plaintext_file:
        plaintext = plaintext_file.read().strip()
    with open(alphabet_file_path, "r", encoding="utf-8") as alphabet_file:
        alphabet = alphabet_file.read().strip()

    substitution = random_substitution(alphabet)
    ciphertext = substitute_text(plaintext, substitution)
    print(ciphertext)
    for k, v in substitution.items():
        print(f"{k} -> {v}", file=sys.stderr)

if __name__ == "__main__":
    main()
