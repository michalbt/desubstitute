module Substitution where

import Data.Map ((!), findWithDefault, insert, Map)
import qualified Data.Map (lookup)
import DistributionMatrix (mapFromKeysAndValues)
import Data.Char (toLower, toUpper)

-- Representation of a substitution as a map from ciphertext characters to plaintext characters.
-- The space character is excluded as it is always expected to map to itself.
type Substitution = Map Char Char

-- Substitute one character from the normalized ciphertext.
substituteNormalizedCiphertextChar :: Substitution -> Char -> Char
substituteNormalizedCiphertextChar substitution char =
    if char == ' ' then ' ' else findWithDefault (error ("invalid character: " ++ [char])) char substitution

-- Substitute the normalized ciphertext. Expects the text to consist only of alphabet characters
-- (keys of the substitution) and spaces, and throws an error if a different character is found.
substituteNormalizedCiphertext :: Substitution -> String -> String
substituteNormalizedCiphertext substitution = map (substituteNormalizedCiphertextChar substitution)

-- Substitute one character from the original (non-normalized) ciphertext.
substituteOriginalCiphertextChar :: Substitution -> Char -> Char
substituteOriginalCiphertextChar substitution char =
    let
        direct = Data.Map.lookup char substitution
        viaCaseChange = toUpper <$> Data.Map.lookup (toLower char) substitution
    in case (direct, viaCaseChange) of
        (Just c, _) -> c
        (Nothing, Just c) -> c
        (Nothing, Nothing) -> char

-- Substitute the original (non-normalized) ciphertext. Handles uppercase characters correctly and keeps non-alphabet
-- characters unchanged.
substituteOriginalCiphertext :: Substitution -> String -> String
substituteOriginalCiphertext substitution = map (substituteOriginalCiphertextChar substitution)

-- Swap two characters in the substitution.
swapChars :: Char -> Char -> Substitution -> Substitution
swapChars char1 char2 substitution =
    let
        value1 = substitution ! char1
        value2 = substitution ! char2
    in
        insert char2 value1 $ insert char1 value2 substitution

-- Create the initial substitution from ciphertext chars ordered by frequency (first argument)
-- and language chars ordered by frequency (second argument).
initialSubstitution :: [Char] -> [Char] -> Substitution
initialSubstitution = mapFromKeysAndValues
