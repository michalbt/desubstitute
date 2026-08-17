module Algorithm where

import DistributionMatrix (createTextMatrix, createReverseAlphabetMap, DistributionMatrix, DistributionVector,
    evaluateDistribution, ReverseAlphabetMap, swapInMatrix)
import Substitution (initialSubstitution, Substitution, swapChars, substituteText)
import FrequencyAnalyzer (orderListByList, textCharFrequencyOrder)

-- State of the character swapping logic of the algorithm.
data SwapperState = SwapperState {
    -- Full alphabet, ordered by frequency in the ciphertext.
    full :: [Char],
    -- Pointer to the element that will be returned as right after resetting left to start.
    nextSectionRight :: [Char],
    -- Pointer to the element that will be returned as left next.
    nextLeft :: [Char],
    -- Pointer to the element that will be returned as right next.
    nextRight :: [Char]
} deriving (Eq, Show)

-- Create an initial swapper state from the alphabet ordered by frequency in the ciphertext (most frequent first).
createState :: [Char] -> SwapperState
createState orderedChars
  | null orderedChars || null (tail orderedChars) = error "not enough characters in alphabet"
  | otherwise = SwapperState {
        full = orderedChars,
        nextSectionRight = tail $ tail orderedChars,
        nextLeft = orderedChars,
        nextRight = tail orderedChars
    }

-- Reset the swapper state to the initial one. Should be called after every successful character swap.
resetState :: SwapperState -> SwapperState
resetState SwapperState { full = fs } = createState fs

-- Get the next two characters to swap and the next swapper state, or Nothing if the algorithm should be terminated.
advanceState :: SwapperState -> Maybe ((Char, Char), SwapperState)
-- should be unreachable
advanceState SwapperState { full = [] } =
    error "invalid state: full is empty"
-- should be unreachable
advanceState SwapperState { nextLeft = [], nextRight = (_:_) } =
    error "invalid state: nextLeft is shorter than nextRight"
-- at the end of this section and no other section => terminate
advanceState SwapperState { nextSectionRight = [], nextRight = [] } =
    Nothing
-- at the end of this section => reset left to start and right to next section
advanceState SwapperState { full = (f:fs), nextSectionRight = (r:nsr), nextRight = [] } =
    Just (
        (f, r),
        SwapperState { full = f:fs, nextSectionRight = nsr, nextLeft = fs, nextRight = nsr }
    )
-- otherwise => advance left and right
advanceState SwapperState { full = fs, nextSectionRight = nsr, nextLeft = (l:ls), nextRight = (r:rs) } =
    Just (
        (l, r),
        SwapperState { full = fs, nextSectionRight = nsr, nextLeft = ls, nextRight = rs }
    )

-- Perform a step of the algorithm and recurse. Return the final substitution.
step ::
    DistributionMatrix -> DistributionMatrix -> ReverseAlphabetMap -> SwapperState -> Double -> Substitution -> Substitution
step textMatrix languageMatrix reverseMap swapperState currentValue substitution = case advanceState swapperState of
    Nothing -> substitution
    Just ((left, right), newSwapperState) ->
        let
            newTextMatrix = swapInMatrix left right reverseMap textMatrix
            newValue = evaluateDistribution newTextMatrix languageMatrix
        in
            if newValue >= currentValue
            then step textMatrix languageMatrix reverseMap newSwapperState currentValue substitution
            else
                let newSubstitution = swapChars left right substitution
                in step newTextMatrix languageMatrix reverseMap (resetState newSwapperState) newValue newSubstitution

-- Run the full algorithm.
run :: [Char] -> String -> DistributionMatrix -> DistributionVector -> Substitution
run alphabet ciphertext languageMatrix languageVector =
    let
        orderedTextChars = textCharFrequencyOrder alphabet ciphertext
        orderedLanguageChars = orderListByList alphabet languageVector
        substitution = initialSubstitution orderedTextChars orderedLanguageChars
        textMatrix = createTextMatrix alphabet (substituteText substitution ciphertext)
        currentValue = evaluateDistribution textMatrix languageMatrix
        reverseMap = createReverseAlphabetMap alphabet
        swapperState = createState orderedTextChars
    in step textMatrix languageMatrix reverseMap swapperState currentValue substitution
