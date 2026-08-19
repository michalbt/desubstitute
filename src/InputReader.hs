module InputReader where

import Data.Char (toLower)

-- Read the ciphertext from the standard input.
readCiphertext :: IO String
readCiphertext = getContents

-- Normalize ciphertext for use in the algorithm. Converts all characters to lowercase, replaces all non-alphabet characters
-- with spaces and adds one space to the start and end of the text.
normalizeCiphertext :: [Char] -> String -> String
normalizeCiphertext alphabet = (' ':) . (++[' ']) . map ((\c -> if c `elem` alphabet then c else ' ') . toLower)
