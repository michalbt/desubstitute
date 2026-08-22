#!/usr/bin/env python3

"""
Debugging tool used for computing the value of the evaluation function for the algorithm.

Usage:
    tools/evaluate.py path/to/digram/frequencies.csv path/to/ciphertext.txt

The substitution needs to be provided on stdin in Haskell's "show" format for Map ("fromList [...]").
"""

import csv
import sys

def normalize(frequencies: dict[str, float]) -> dict[str, float]:
    total = sum(frequencies.values())
    for digram in frequencies.keys():
        frequencies[digram] /= total
    return frequencies

def read_digram_frequencies(path: str) -> dict[str, float]:
    data = {}
    with open(path, "r", encoding="utf-8") as file:
        reader = csv.DictReader(file, delimiter=",")
        for row in reader:
            data[row["digram"]] = float(row["count"])
    return normalize(data)

def parse_substitution(hs_show_output: str) -> dict[str, str]:
    return dict(map(
        lambda s: s.split("','"),
        hs_show_output.removeprefix("fromList [('").removesuffix("')]").split("'),('")
    ))

def substitute(text: str, substitution: dict[str, str]) -> str:
    result = ""
    for char in text:
        char = char.lower()
        if char in substitution:
            result += substitution[char]
        else:
            result += " "
    return " " + result + " "

def get_frequencies(text: str, alphabet: list[str]) -> dict[str, float]:
    frequencies = {char1 + char2: 0 for char1 in alphabet for char2 in alphabet}
    for char1, char2 in zip(text, text[1:]):
        if char1 + char2 in frequencies:
            frequencies[char1 + char2] += 1
    return normalize(frequencies)

def evaluate(language_frequencies: dict[str, float], ciphertext: str, substitution: dict[str, str]) -> float:
    substituted_text = substitute(ciphertext, substitution)
    text_frequencies = get_frequencies(substituted_text, list(substitution.keys()))
    total = 0.0
    for digram in language_frequencies.keys():
        total += abs(language_frequencies[digram] - text_frequencies[digram])
    return total

def main():
    frequencies_path = sys.argv[1]
    ciphertext_path = sys.argv[2]

    language_frequencies = read_digram_frequencies(frequencies_path)
    with open(ciphertext_path, "r", encoding="utf-8") as file:
        ciphertext = file.read()
    substitution = parse_substitution(input("Substitution: "))
    value = evaluate(language_frequencies, ciphertext, substitution)
    print(value)

if __name__ == "__main__":
    main()
