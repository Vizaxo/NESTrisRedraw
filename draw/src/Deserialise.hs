module Deserialise where

import Data.Vector.Sized as V

import Block
import Board
import Utils

testInput = "0000000000,0000000000,0000000000,0000000000,0000000000,0000000000,0000000000,0000000000,3000000000,3000000000,3000000000,3000000000,3000000000,3300000000,3311000000,3331100100,1133311100,1123111110,1122111310,1122113310"

deserialise :: String -> Maybe Board
deserialise b = Board <$> (fromList =<< (traverse deserialiseLine (splitOn ',' b)))

deserialiseLine :: String -> Maybe Line
deserialiseLine l = Line <$> (fromList =<< (traverse deserialiseBlock l))

deserialiseBlock :: Char -> Maybe Block
deserialiseBlock '0' = Just blankBlock
deserialiseBlock '1' = Just (Block (Just White))
deserialiseBlock '2' = Just (Block (Just ColourA))
deserialiseBlock '3' = Just (Block (Just ColourB))
deserialiseBlock _ = Nothing
