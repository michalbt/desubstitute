module FileReader where

import System.IO (openFile, IOMode (ReadMode), hSetEncoding, utf8, hGetContents)
import qualified Data.Bifunctor (first, second)
import DistributionMatrix (DistributionMatrix, mapFromKeysAndValues, normalizeMatrix, DistributionVector, normalizeVector)
import Text.Read (readMaybe)
import qualified Data.Map (lookup)
import Data.Maybe (listToMaybe)
import Control.Monad ((<=<))

-- Split a string once on the first occurence of the separator, or returns Nothing if the separator is not present.
splitOnce :: Char -> String -> Maybe (String, String)
splitOnce _ "" = Nothing
splitOnce separator (first:rest) =
    if first == separator then Just ("", rest) else Data.Bifunctor.first (first:) <$> splitOnce separator rest

-- Parse a 2-column CSV file with the provided separator, expecting the first column to be text and the second numeric.
-- Does not support quoted fields. Ignores the first row if the provided predicate returns true.
-- Returns Nothing on parse error.
parseTwoColumnCsvFile :: Char -> ((String, String) -> Bool) -> String -> Maybe [(String, Double)]
parseTwoColumnCsvFile separator ignoreFirstRowPredicate text = do
    allRows <- mapM (splitOnce separator) (lines text)
    firstRow <- listToMaybe allRows
    let dataRows = if ignoreFirstRowPredicate firstRow then tail allRows else allRows
    mapM (unwrapSecondMaybe . Data.Bifunctor.second readMaybe) dataRows
    where
        unwrapSecondMaybe (_, Nothing) = Nothing
        unwrapSecondMaybe (x, Just y) = Just (x, y)

-- Read a file on the specified path with the UTF-8 encoding.
readUtf8 :: String -> IO String
readUtf8 path = do
    handle <- openFile path ReadMode
    hSetEncoding handle utf8
    hGetContents handle

-- Create a language distribution matrix from a parsed CSV containing digram frequencies. Expects format (digram, count).
-- If the first row does not conform (e.g. it is a header), it is ignored. Returns Nothing on error.
createLanguageMatrix :: [Char] -> [(String, Double)] -> Maybe DistributionMatrix
createLanguageMatrix alphabet records =
    let digramMap = uncurry mapFromKeysAndValues $ unzip records
    in normalizeMatrix <$> mapM (\char1 -> mapM (\char2 -> Data.Map.lookup [char1, char2] digramMap) alphabet) alphabet

-- Create a language distribution vector from a parsed CSV containing character frequencies.
-- Expects format (character, count). If the first row does not conform (e.g. it is a header), it is ignored.
-- Returns Nothing on error.
createLanguageVector :: [Char] -> [(String, Double)] -> Maybe DistributionVector
createLanguageVector alphabet records =
    let characterMap = uncurry mapFromKeysAndValues $ unzip records
    in normalizeVector <$> mapM (\char -> Data.Map.lookup [char] characterMap) alphabet

-- Read a file with digram frequencies and parse them to a language distribution matrix.
readLanguageMatrix :: String -> [Char] -> Char -> IO (Maybe DistributionMatrix)
readLanguageMatrix path alphabet separator =
    (createLanguageMatrix alphabet <=< parseTwoColumnCsvFile separator ignoreFirstRowPredicate) <$> readUtf8 path
    where ignoreFirstRowPredicate (s1, _) = length s1 /= 2

-- Read a file with character frequencies and parse them to a language distribution vector.
readLanguageVector :: String -> [Char] -> Char -> IO (Maybe DistributionVector)
readLanguageVector path alphabet separator =
    (createLanguageVector alphabet <=< parseTwoColumnCsvFile separator ignoreFirstRowPredicate) <$> readUtf8 path
    where ignoreFirstRowPredicate (s1, _) = length s1 /= 1
