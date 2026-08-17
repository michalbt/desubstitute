module Substitution where

import Data.Map ((!), findWithDefault, insert, Map)
import DistributionMatrix (mapFromKeysAndValues)

-- Representation of a substitution as a map from ciphertext characters to plaintext characters.
-- The space character is exluded as it is always expected to map to itself.
type Substitution = Map Char Char

-- Resolve one ciphertext character using a given substitution.
-- If the character is not in the map, it is returned unchanged (e.g. for space).
substituteChar :: Substitution -> Char -> Char
substituteChar substitution char = findWithDefault char char substitution

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
