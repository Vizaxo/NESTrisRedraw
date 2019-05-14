module Board where

import Data.Finite
import Data.Vector.Sized as V

import Block

-- 10-wide lines
data Line = Line { unLine :: (Vector 10 Block) }
  deriving Show

blankLine = Line (V.replicate blankBlock)

-- 20-high board
data Board
  = Board (Vector 20 Line)
  deriving Show

blockAt :: Board -> Finite 10 -> Finite 20 -> Block
blockAt (Board board) x y = V.index (unLine $ V.index board y) x

blankBoard = Board (V.replicate blankLine)
