{-# LANGUAGE AllowAmbiguousTypes #-}
module Utils where

import Data.List
import Data.Proxy
import GHC.TypeNats

splitOn :: Eq a => a -> [a] -> [[a]]
splitOn y xs = splitOn' xs [] where
  splitOn' (x:xs) acc | x == y = reverse acc : splitOn' xs []
                      | otherwise = splitOn' xs (x:acc)
  splitOn' [] acc = [reverse acc]
