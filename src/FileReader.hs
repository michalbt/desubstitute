module FileReader where

import System.IO (openFile, IOMode (ReadMode), hSetEncoding, utf8, hGetContents)
import qualified Data.Bifunctor (first, second)
import DistributionMatrix (DistributionMatrix, mapFromKeysAndValues, normalizeMatrix, DistributionVector, normalizeVector)
import Text.Read (readMaybe)
import Data.Map (Map)
import qualified Data.Map (lookup)
import Control.Monad ((<=<))
import Data.Char (isSpace)
import Data.List (dropWhileEnd)

-- Return type for all fallible operations in this module.
type Fallible a = Either String a

-- Split a string once on the first occurence of the separator.
splitOnce :: Char -> String -> Fallible (String, String)
splitOnce _ "" = Left "separator not present"
splitOnce separator (first:rest) =
    if first == separator then Right ("", rest) else Data.Bifunctor.first (first:) <$> splitOnce separator rest

-- Parse a 2-column CSV file with the provided separator, expecting the first column to be text and the second numeric.
-- Does not support quoted fields. Ignores the first row if the provided predicate returns true.
parseTwoColumnCsvFile :: Char -> ((String, String) -> Bool) -> String -> Fallible [(String, Double)]
parseTwoColumnCsvFile separator ignoreFirstRowPredicate text = do
    allRows <- mapM (splitOnce separator) (lines text)
    firstRow <- if null allRows then Left "CSV file is empty" else Right (head allRows)
    let dataRows = if ignoreFirstRowPredicate firstRow then tail allRows else allRows
    mapM (unwrapSecondMaybe . Data.Bifunctor.second readMaybe) dataRows
    where
        unwrapSecondMaybe (_, Nothing) = Left "value is not a number"
        unwrapSecondMaybe (x, Just y) = Right (x, y)

-- Read a file on the specified path with the UTF-8 encoding.
readUtf8 :: String -> IO String
readUtf8 path = do
    handle <- openFile path ReadMode
    hSetEncoding handle utf8
    hGetContents handle

-- Try looking up a key in a map.
tryLookup :: (Ord a, Show a) => Map a b -> a -> Fallible b
tryLookup map_ key = maybe (Left ("key " ++ show key ++ " not found in map")) Right $ Data.Map.lookup key map_

-- Create a language distribution matrix from a parsed CSV containing digram frequencies. Expects format (digram, count).
-- If the first row does not conform (e.g. it is a header), it is ignored.
createLanguageMatrix :: [Char] -> [(String, Double)] -> Fallible DistributionMatrix
createLanguageMatrix alphabet records =
    let digramMap = uncurry mapFromKeysAndValues $ unzip records
    in normalizeMatrix <$> mapM (\char1 -> mapM (\char2 -> tryLookup digramMap [char1, char2]) alphabet) alphabet

-- Create a language distribution vector from a parsed CSV containing character frequencies.
-- Expects format (character, count). If the first row does not conform (e.g. it is a header), it is ignored.
createLanguageVector :: [Char] -> [(String, Double)] -> Fallible DistributionVector
createLanguageVector alphabet records =
    let characterMap = uncurry mapFromKeysAndValues $ unzip records
    in normalizeVector <$> mapM (\char -> tryLookup characterMap [char]) alphabet

-- Read a file with digram frequencies and parse them to a language distribution matrix.
readLanguageMatrix :: String -> [Char] -> Char -> IO (Fallible DistributionMatrix)
readLanguageMatrix path alphabet separator =
    (createLanguageMatrix alphabet <=< parseTwoColumnCsvFile separator ignoreFirstRowPredicate) <$> readUtf8 path
    where ignoreFirstRowPredicate (s1, _) = length s1 /= 2

-- Read a file with character frequencies and parse them to a language distribution vector.
readLanguageVector :: String -> [Char] -> Char -> IO (Fallible DistributionVector)
readLanguageVector path alphabet separator =
    (createLanguageVector alphabet <=< parseTwoColumnCsvFile separator ignoreFirstRowPredicate) <$> readUtf8 path
    where ignoreFirstRowPredicate (s1, _) = length s1 /= 1

-- Read a file with the alphabet, trimming any whitespace from start and end.
readAlphabet :: String -> IO [Char]
readAlphabet path = dropWhile isSpace . dropWhileEnd isSpace <$> readUtf8 path
