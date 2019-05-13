module Piece where

import Block

data Line = Line Block Block Block Block Block
  deriving Show

data Piece = Piece Line Line Line Line Line
  deriving Show

data PieceDescription = PieceDescription Piece Piece Piece Piece
  deriving Show

blankLine = Line blankBlock blankBlock blankBlock blankBlock blankBlock

iFlat :: Piece
iFlat = Piece blankLine blankLine i blankLine blankLine where
  i = Line filled filled filled filled blankBlock
  filled = Block (Just Mid)

iTall :: Piece
iTall = Piece iLine iLine iLine iLine blankLine where
  iLine = Line blankBlock blankBlock (Block (Just Mid)) blankBlock blankBlock

i :: PieceDescription
i = PieceDescription iFlat iTall iFlat iTall
