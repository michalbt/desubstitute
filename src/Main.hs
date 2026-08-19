module Main where

import Algorithm (run)
import FileReader (readAlphabet, readLanguageMatrix, readLanguageVector)
import InputReader (normalizeCiphertext, readCiphertext)
import Substitution (substituteText)

{-
-- Expected substitution: a -> b, b -> a, c -> c

alphabet :: [Char]
alphabet = "abc"

ciphertext :: String
ciphertext = "aababaaacbaaba"
-- Expected plaintext: "bbababbbcabbab"

languageMatrix :: DistributionMatrix
languageMatrix = [
    [0.01, 0.24, 0.05], -- starting with plaintext 'a' - ciphertext 'b'
    [0.22, 0.26, 0.07], -- starting with plaintext 'b' - ciphertext 'a'
    [0.07, 0.05, 0.03]] -- starting with plaintext 'c' - ciphertext 'c'

languageVector :: DistributionVector
languageVector = [0.3, 0.55, 0.15]

includeSpaceInDigrams :: Bool
includeSpaceInDigrams = False
-}

main :: IO ()
main = do
    putStrLn "Loading data..."
    let separator = ','
    alphabet <- readAlphabet "data/english/alphabet.txt"
    rawCiphertext <- readCiphertext
    let normalizedCiphertext = normalizeCiphertext alphabet rawCiphertext
    maybeLanguageMatrix <- readLanguageMatrix "data/english/digrams.csv" alphabet separator
    case maybeLanguageMatrix of
        Left err -> putStrLn ("Failed to load language digram frequencies: " ++ err)
        Right languageMatrix -> do
            maybeLanguageVector <- readLanguageVector "data/english/characters.csv" alphabet separator
            case maybeLanguageVector of
                Left err -> putStrLn ("Failed to load language character frequencies" ++ err)
                Right languageVector -> do
                    putStrLn "Decoding..."
                    let includeSpaceInDigrams = False
                    let substitution = run alphabet normalizedCiphertext languageMatrix languageVector includeSpaceInDigrams
                    print substitution
                    let decodedText = substituteText substitution rawCiphertext
                    putStrLn decodedText
