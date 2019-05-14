module Board where

import Block

import Data.Vector.Sized as V

-- 10-wide lines
data Line = Line (Vector 10 Block)
  deriving Show

blankLine = Line (V.replicate blankBlock)

-- 20-high board
data Board
  = Board (Vector 20 Line)
  deriving Show

blankBoard = Board (V.replicate blankLine)
