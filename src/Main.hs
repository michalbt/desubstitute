module Main where

import Algorithm (advanceState, SwapperState, createState)

test :: SwapperState -> [(Char, Char)]
test state = case advanceState state of
    Just (chars, newState) -> chars : test newState
    Nothing -> []

initialState :: SwapperState
initialState = createState ['a', 'b', 'c', 'd', 'e', 'f']

main :: IO ()
main = do
    print $ test initialState
