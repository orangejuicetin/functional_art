module Main (main) where

import Control.Monad.Reader
import Control.Monad.State
import Graphics.Rendering.Cairo
import System.Random

data World = World
  { worldWidth :: Double,
    worldHeight :: Double,
    scaleFactor :: Double
  }

type Generate a = StateT StdGen (Reader World) a

runGenerate :: World -> StdGen -> Generate a -> a
runGenerate world rng scene =
  flip runReader world . fmap fst . flip runStateT rng $ scene

bg :: Generate (Render ())
bg = do
  (World w h _) <- ask
  return $ do
    setSourceRGBA 0 0 0 1
    rectangle 0 0 w h
    fill

draw :: Generate (Render ())
draw = do
  (World w h _) <- ask
  red <- state $ uniformR (0, 1)
  green <- state $ uniformR (0, 1)
  blue <- state $ uniformR (0, 1)
  return $ do
    setSourceRGBA red green blue 1
    rectangle (w / 4) (h / 4) (w / 2) (h / 2)
    fill

sketch :: Generate (Render ())
sketch = do
  rs <- sequence [bg, draw]
  return $ sequence_ rs

main :: IO ()
main = do
  let world = World 500 200 1
  rng <- initStdGen
  surface <-
    createImageSurface
      FormatARGB32
      (round $ worldWidth world)
      (round $ worldHeight world)
  renderWith surface $ do
    scale (scaleFactor world) (scaleFactor world)
    runGenerate world rng sketch
  surfaceWriteToPNG surface "out.png"
