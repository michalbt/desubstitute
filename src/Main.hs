module Main where

import Algorithm (run)
import FileReader (readAlphabet, readLanguageMatrix, readLanguageVector)
import InputReader (normalizeCiphertext, readCiphertext)
import Substitution (substituteOriginalCiphertext)
import Data.Char (isSpace)

main :: IO ()
main = do
    putStrLn "Loading data..."
    let separator = ','
    alphabet <- readAlphabet "data/english/alphabet.txt"
    rawCiphertext <- readCiphertext
    let normalizedCiphertext = normalizeCiphertext alphabet rawCiphertext
    if all isSpace normalizedCiphertext then
        putStrLn "Ciphertext is empty"
    else do
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
                        let decodedText = substituteOriginalCiphertext substitution rawCiphertext
                        putStrLn decodedText
