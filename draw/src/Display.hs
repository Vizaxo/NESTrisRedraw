module Display where

import Data.Maybe
import Data.Finite
import Data.Vector.Sized (Vector)
import qualified Data.Vector.Sized as V
import GHC.TypeNats
import qualified Codec.Picture as P

import Board
import Block
import Utils

prettyPrintBoard :: Board -> String
prettyPrintBoard (Board ls) = unlines $ V.toList (prettyPrintLine <$> ls)

prettyPrintLine :: Line -> String
prettyPrintLine (Line bs) = V.toList (prettyPrintBlock <$> bs)

prettyPrintBlock :: Block -> Char
prettyPrintBlock (Block Nothing) = ' '
prettyPrintBlock (Block (Just White)) = '1'
prettyPrintBlock (Block (Just ColourA)) = '2'
prettyPrintBlock (Block (Just ColourB)) = '3'

--data P.PixelRGBA8 = Pixel Word8 Word8 Word8 Word8
  --deriving Show
data Image x y = Image (Vector y (Vector x P.PixelRGBA8))
  deriving Show

pixelAt :: Image x y -> Finite x -> Finite y -> P.PixelRGBA8
pixelAt (Image ys) x y = V.index (V.index ys y) x

data Palette = Palette
  { colourA :: P.PixelRGBA8
  , colourB :: P.PixelRGBA8
  }

whitePix, blackPix :: P.PixelRGBA8
whitePix = P.PixelRGBA8 0xff 0xff 0xff 0xff
blackPix = P.PixelRGBA8 0x00 0x00 0x00 0xff
redPix = P.PixelRGBA8 0xff 0x00 0x00 0xff

type BlockImage = Image 8 8

whiteBlock :: P.PixelRGBA8 -> BlockImage
whiteBlock border = Image $ fromJust $ V.fromList $ fmap (fromJust . V.fromList) $
  [ [whitePix] ++ (replicate 6 border) ++ [blackPix] ] ++
  replicate 5 ([border] ++ replicate 5 whitePix ++ [border, blackPix]) ++
  [ replicate 7 border ++ [blackPix] ] ++
  [ replicate 8 blackPix ]

colourBlock :: P.PixelRGBA8 -> BlockImage
colourBlock colour = Image $
  (whitePix `V.cons` V.replicate colour `V.snoc` blackPix)
  `V.cons`
  ((colour `V.cons` V.replicate @2 whitePix V.++ V.replicate colour `V.snoc` blackPix)
  `V.cons`
  ((colour `V.cons` (whitePix `V.cons` V.replicate colour `V.snoc` blackPix))
  `V.cons`
  (V.replicate (V.replicate colour `V.snoc` blackPix))
  `V.snoc`
  (V.replicate blackPix)))

blackBlock :: BlockImage
blackBlock = Image $ V.replicate (V.replicate blackPix)

blockToImage :: Palette -> Block -> BlockImage
blockToImage Palette{..} (Block Nothing) = blackBlock
blockToImage Palette{..} (Block (Just White)) = whiteBlock colourA
blockToImage Palette{..} (Block (Just ColourA)) = colourBlock colourA
blockToImage Palette{..} (Block (Just ColourB)) = colourBlock colourB

makeImage :: forall x y. (KnownNat x, KnownNat y) => Image x y -> P.Image P.PixelRGBA8
makeImage img = P.generateImage pixelRenderer (natValue @x) (natValue @y)
   where pixelRenderer x y = pixelAt img (finite (fromIntegral x)) (finite (fromIntegral y))

writeImage :: forall x y. (KnownNat x, KnownNat y) => String -> Image x y -> IO ()
writeImage path img = P.writePng path (makeImage img)
