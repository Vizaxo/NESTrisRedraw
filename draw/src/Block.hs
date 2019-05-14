module Block where

data Colour = White | ColourA | ColourB
  deriving Show

data Block = Block (Maybe Colour)
  deriving Show

blankBlock :: Block
blankBlock = Block Nothing
