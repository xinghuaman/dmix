module Analyzer (analyze) where

import Insn

import Data.Array
import Data.Maybe

objArray :: Object -> Array Int Insn
objArray obj = listArray (0, (length obj)) obj

data PipelineState = PipelineState
  { ifetch :: Maybe Int
  , dcd :: Maybe Int
  , mem :: Maybe Int
  , ex :: Maybe Int
  , wb :: Maybe Int } deriving (Show, Eq)

initialState :: PipelineState 
initialState = PipelineState { ifetch = Just 0, dcd = Nothing, mem = Nothing, ex = Nothing, wb = Nothing }

isValidAddr :: Array Int a -> Int -> Bool
isValidAddr obja i = (b <= i) && (i < t)
  where (b, t) = bounds obja

isValidAddrM :: Array Int a -> Maybe Int -> Bool
isValidAddrM obja (Just i) = isValidAddr obja i
isValidAddrM obja Nothing  = True

isValidState :: Array Int a -> PipelineState -> Bool
isValidState _ PipelineState { ifetch = Nothing
                             , dcd = Nothing
                             , mem = Nothing
                             , ex = Nothing
                             , wb = Nothing } = False
isValidState obja ps = v (ifetch ps) && v (dcd ps) && v (mem ps) && v (ex ps) && v (wb ps)
  where v = isValidAddrM obja

invalidState :: PipelineState
invalidState = PipelineState
               { ifetch = Just 0
               , dcd = Nothing
               , mem = Nothing
               , ex = Nothing
               , wb = Nothing }

tryAdvanceAddr :: Array Int a -> Maybe Int -> Maybe Int
tryAdvanceAddr obja (Just i) = if isValidAddr obja (i + 1) then Just (i + 1) else Nothing
tryAdvanceAddr obja Nothing  = Nothing

nextState :: PipelineState -> Maybe Int -> PipelineState
nextState curr ifetchAddr = PipelineState
                            { ifetch = ifetchAddr
                            , dcd = ifetch curr
                            , mem = dcd curr
                            , ex = mem curr
                            , wb = ex curr }

nextStates :: Array Int Insn -> PipelineState -> [PipelineState]
nextStates obja curr = filter (isValidState obja) [bnt, bt]
  where
    bnt :: PipelineState
    bnt = nextState curr $ tryAdvanceAddr obja (ifetch curr)

    bt :: PipelineState
    bt = case (ex curr) of
         Nothing -> invalidState
         Just jex -> case (branchTargetAddr $ obja!jex) of
                     Nothing -> invalidState
                     Just ja -> nextState curr (Just ja)


possibleStates :: Array Int Insn -> [PipelineState]
possibleStates obja = populateStates obja initialState []
  where
    populateStates :: Array Int Insn -> PipelineState -> [PipelineState] -> [PipelineState]
    populateStates obja s ss | (elem s ss) = ss -- Already explored
                             | otherwise   = foldr step (s:ss) nexts
                             where 
                               nexts :: [PipelineState]
                               nexts = nextStates obja s

                               step :: PipelineState -> [PipelineState] -> [PipelineState]
                               step = populateStates obja

analyze :: Object -> [String]
analyze obj = map show states
  where
    obja :: Array Int Insn
    obja = objArray obj

    states :: [PipelineState]
    states = possibleStates obja
