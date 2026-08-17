module Main where

import Algorithm (run)
import DistributionMatrix (DistributionMatrix, DistributionVector)

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

main :: IO ()
main = do
    print $ run alphabet ciphertext languageMatrix languageVector includeSpaceInDigrams
