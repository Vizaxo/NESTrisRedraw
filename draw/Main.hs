module Main where

import Control.Concurrent
import Control.Monad
import Control.Monad.State
import qualified Codec.Picture as P
import Data.Time.Clock.System
import Data.Int
import System.Process
import System.IO


import Deserialise
import Display

fps :: MonadIO m => Int -> m a -> m ()
fps hz m = forever $ do
  start <- liftIO getSystemTime
  m
  end <- liftIO getSystemTime
  let diff = diffSysTime start end
  -- print (round (1 / (fromIntegral hz) * 1000000)) - (fromIntegral (diff * 1000))
  liftIO $ threadDelay $ (round ((1 / (fromIntegral hz)) * 1000000)) - (fromIntegral (diff `div` 1000))

diffSysTime :: SystemTime -> SystemTime -> Int64 -- nanoseconds
diffSysTime (MkSystemTime as an) (MkSystemTime bs bn) = ((bs - as) * 1000 * 1000 * 1000) + (fromIntegral bn - fromIntegral an)

main :: IO ()
main = do
  (_, Just stdout, _, _) <- createProcess (shell "python3 ../detect/video_stream.py 2>/dev/null"){std_out = CreatePipe}
  --forkIO stream
  start <- liftIO getSystemTime
  void $ flip runStateT (0 :: Int, start) $ forever $ do
    (frameNo, start) <- get
    liftIO $ do
      --threadDelay (1000 `div` 50) --TODO: properly 50fps
      frame <- liftIO $ hGetLine stdout
      let (Just board) = deserialise frame
      let filename = "frame" <> show frameNo <> ".png"
      putStrLn $ "Writing file " <> filename
      P.writePng ("/home/mitch/tmp/tetris/buf/" <> filename) (displayBoard board level18Palette)
      --void $ system $ "convert '/home/mitch/tmp/tetris/buf/" <> filename <> "' -interpolate Nearest -filter point -resize 200% '/home/mitch/tmp/tetris/buf/resized/" <> filename <> "'"
    if frameNo >= 199 then do
      end <- liftIO getSystemTime
      let waitTime = (round ((1 / (fromIntegral 50)) * 1000000 * 200)) - (fromIntegral (diffSysTime start end `div` 1000))
      liftIO $ putStrLn $ "Waiting for " <> show waitTime
      liftIO $ threadDelay $ (round ((1 / (fromIntegral 50)) * 1000000 * 200)) - (fromIntegral (diffSysTime start end `div` 1000))
      start <- liftIO getSystemTime
      put (0, start)
    else modify (\(a,b) -> (a+1, b))

stream :: IO ()
stream = do
  threadDelay 2000000
  void $ system "ffmpeg -re -framerate 50 -loop 1 -start_number 0 -i '/home/mitch/tmp/tetris/buf/resized/frame%d.png' -f mpegts udp://localhost:8001"
