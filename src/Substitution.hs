module Substitution where

import Data.Map (Map, (!), insert)
import DistributionMatrix (mapFromKeysAndValues)

-- Representation of a substitution as a map from ciphertext characters to plaintext characters.
type Substitution = Map Char Char

-- Resolve one ciphertext character using a given substitution.
substituteChar :: Substitution -> Char -> Char
substituteChar substitution char = substitution ! char

-- Resolve the ciphertext using a given substitution.
substituteText :: Substitution -> String -> String
substituteText substitution = map (substituteChar substitution)

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
