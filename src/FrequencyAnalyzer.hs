module FrequencyAnalyzer where

import Data.List (sortBy)
import Data.Ord (comparing, Down (Down))

-- Return the number of occurences of an item in a list.
count :: Eq a => a -> [a] -> Int
count item = length . filter (== item)

-- Order items in the first list based on matching values in the second list in descending order.
orderListByList :: Ord b => [a] -> [b] -> [a]
orderListByList items weights = map fst $ sortBy (comparing (Down . snd)) $ zip items weights

-- Count the number of occurences of each alphabet character in the text.
textCharCounts :: [Char] -> String -> [Int]
textCharCounts alphabet text = map (`count` text) alphabet

-- Order characters in alphabet based on frequency in text.
textCharFrequencyOrder :: [Char] -> String -> [Char]
textCharFrequencyOrder alphabet text = orderListByList alphabet (textCharCounts alphabet text)

-- Get all digrams in a text.
-- TODO: handle spaces!
allTextDigrams :: String -> [(Char, Char)]
allTextDigrams text = zip text (tail text)

-- Count the number of occurences of each digram of alphabet characters in the text.
textDigramCounts :: [Char] -> String -> [[Int]]
textDigramCounts alphabet text = map (\char1 -> map (\char2 -> count (char1, char2) $ allTextDigrams text) alphabet) alphabet
