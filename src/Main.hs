module Main where

import Algorithm (run)
import FileReader (readAlphabet, readLanguageMatrix, readLanguageVector)
import InputReader (normalizeCiphertext, readCiphertext)
import Substitution (substituteOriginalCiphertext, substitutionToString)
import Data.Char (isSpace)
import Options.Applicative (execParser)
import Cli (
    CliOptions(
        alphabetPath, characterFrequenciesPath, digramFrequenciesPath, printSubstitution, separatorChar, spaceInDigrams
    ), parser)
import System.IO (hPutStrLn, stderr)

main :: IO ()
main = do
    options <- execParser parser
    let separator = separatorChar options
    alphabet <- readAlphabet (alphabetPath options)
    rawCiphertext <- readCiphertext
    let normalizedCiphertext = normalizeCiphertext alphabet rawCiphertext
    if all isSpace normalizedCiphertext then
        hPutStrLn stderr "Ciphertext is empty"
    else do
        maybeLanguageMatrix <- readLanguageMatrix (digramFrequenciesPath options) alphabet separator
        case maybeLanguageMatrix of
            Left err -> hPutStrLn stderr ("Failed to load language digram frequencies: " ++ err)
            Right languageMatrix -> do
                maybeLanguageVector <- readLanguageVector (characterFrequenciesPath options) alphabet separator
                case maybeLanguageVector of
                    Left err -> hPutStrLn stderr ("Failed to load language character frequencies" ++ err)
                    Right languageVector -> do
                        let substitution = run alphabet normalizedCiphertext languageMatrix languageVector (spaceInDigrams options)
                        let decodedText = substituteOriginalCiphertext substitution rawCiphertext
                        if printSubstitution options then do
                            putStrLn $ substitutionToString alphabet substitution
                            putStrLn decodedText
                        else putStrLn decodedText
