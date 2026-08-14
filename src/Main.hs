module Main where

import DistributionMatrix (evaluateDistribution)

test :: Double
test = evaluateDistribution [[1.0, 2.0], [3.0, 4.0]] [[1.0, 2.0], [3.0, 4.0]]

main :: IO ()
main = do
    print test
