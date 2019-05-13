module Board where

import Block

-- 10-wide lines
data Line = Line Block Block Block Block Block Block Block Block Block Block
  deriving Show

blankLine = Line blankBlock blankBlock blankBlock blankBlock blankBlock blankBlock blankBlock blankBlock blankBlock blankBlock

-- 20-high board
data Board
  = Board
  Line Line Line Line Line Line Line Line Line Line
  Line Line Line Line Line Line Line Line Line Line
  deriving Show

blankBoard = Board blankLine blankLine blankLine blankLine blankLine blankLine blankLine blankLine blankLine blankLine blankLine blankLine blankLine blankLine blankLine blankLine blankLine blankLine blankLine blankLine
