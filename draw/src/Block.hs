module Block where

data Colour = Dark | Mid | Light
  deriving Show

data Block = Block (Maybe Colour)
  deriving Show

blankBlock :: Block
blankBlock = Block Nothing
