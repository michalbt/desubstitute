module Main where

import DistributionMatrix (evaluate)

test = evaluate [[1.0, 2.0], [3.0, 4.0]] [[1.0, 2.0], [3.0, 4.0]]

main :: IO ()
main = do
    print test
