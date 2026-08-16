module DistributionMatrix where

import Data.Map (Map, (!), insert, empty)
import FrequencyAnalyzer (textDigramCounts)

-- Matrix of digram frequencies. When indexing first by i and then by j, the element at that position is the frequency
-- of a digram AB, where A is the i-th and B is the j-th element of the alphabet.
-- This can either be a frequency in the ciphertext deciphered by the current substitution (in case of textMatrix),
-- or an expected frequency in the language (in case of languageMatrix).
type DistributionMatrix = [[Double]]

-- Vector of character frequencies. Similar to DistributionMatrix, but only used for the language.
type DistributionVector = [Double]

-- Mapping from alphabet characters to matrix indices. Arbitrary and never changing.
type ReverseAlphabetMap = Map Char Int

-- Create a map from two lists - keys and values.
mapFromKeysAndValues :: Ord a => [a] -> [b] -> Map a b
mapFromKeysAndValues keys values = foldr (uncurry insert) empty $ zip keys values

-- Create a reverse alphabet mapping from an alphabet.
createReverseAlphabetMap :: [Char] -> ReverseAlphabetMap
createReverseAlphabetMap alphabet = mapFromKeysAndValues alphabet [0..]

-- Compute the evaluation function using the text and language distribution matrix.
evaluateDistribution :: DistributionMatrix -> DistributionMatrix -> Double
evaluateDistribution textMatrix languageMatrix =
    sum $ zipWith (\textRow languageRow -> sum $ zipWith (\x y -> abs (x - y)) textRow languageRow) textMatrix languageMatrix

-- Replace list element at a specified position with a different element, returning the original.
replaceAt :: Int -> a -> [a] -> (a, [a])
replaceAt _ _ [] = error "index to replace not in bounds"
replaceAt 0 new (x:xs) = (x, new:xs)
replaceAt idx new (x:xs) =
    let (old, rest) = replaceAt (idx - 1) new xs
    in (old, x:rest)

-- Swap list elements at specified positions.
swapAt :: Int -> Int -> [a] -> [a]
swapAt _ _ [] = error "indices to swap not in bounds"
swapAt idx1 idx2 (x:xs)
  | idx1 > idx2 = swapAt idx2 idx1 (x:xs)
  | idx1 == 0 = uncurry (:) (replaceAt (idx2 - 1) x xs)
  | otherwise = x : swapAt (idx1 - 1) (idx2 - 1) xs

-- Swap rows at specified indices of the distribution matrix.
swapRows :: Int -> Int -> DistributionMatrix -> DistributionMatrix
swapRows = swapAt

-- Swap columns at specified indices of the distribution matrix.
swapCols :: Int -> Int -> DistributionMatrix -> DistributionMatrix
swapCols col1 col2 = map (swapAt col1 col2)

-- Swap rows and columns corresponding to specified ciphertext characters in the distribution matrix.
swapInMatrix :: Char -> Char -> ReverseAlphabetMap -> DistributionMatrix -> DistributionMatrix
swapInMatrix char1 char2 reverseMap =
    let
        idx1 = reverseMap ! char1
        idx2 = reverseMap ! char2
    in swapCols idx1 idx2 . swapRows idx1 idx2

createTextMatrix :: [Char] -> String -> DistributionMatrix
createTextMatrix alphabet text =
    let
        digramCounts = textDigramCounts alphabet text
        digramCountsSum = fromIntegral $ sum $ map sum digramCounts
    in map (map ((/ digramCountsSum) . fromIntegral)) digramCounts
