module DistributionMatrix where

import Data.Map (Map, (!))

type Digram = (Char, Char)

-- Matrix of digram frequencies.
type DistributionMatrix = [[Double]]

-- Compute the evaluation function using the text and language distribution matrix.
evaluate :: DistributionMatrix -> DistributionMatrix -> Double
evaluate textMatrix originalMatrix = sum $ zipWith (\textRow originalRow -> sum $ zipWith (\x y -> abs (x - y)) textRow originalRow) textMatrix originalMatrix

-- Replace list element at a specified position with a different element, returning the original.
replaceAt :: Int -> a -> [a] -> (a, [a])
replaceAt _ _ [] = error "index to replace not in bounds"
replaceAt 0 new (x:xs) = (x, new:xs)
replaceAt idx new (x:xs) =
    let (old, tail) = replaceAt (idx - 1) new xs
    in (old, x:tail)

-- Swap list elements at specified positions.
swapAt :: Int -> Int -> [a] -> [a]
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

-- Swap both rows and columns at specified indices of the distribution matrix.
swapBoth :: Int -> Int -> DistributionMatrix -> DistributionMatrix
swapBoth idx1 idx2 = swapCols idx1 idx2 . swapRows idx1 idx2
