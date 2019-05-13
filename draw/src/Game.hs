module Game where

import Board
import Piece

data Game = Game
  { board :: Board
  , pieceX :: Int
  , pieceY :: Int
  , activePiece :: Piece
  , nextPiece :: PieceDescription
  }
  deriving Show

newGame :: Game
newGame = Game blankBoard 4 0 iFlat i

collisionp :: Game -> Bool
collisionp Game{..} = undefined
