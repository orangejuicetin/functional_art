module Main (main) where

import Control.Monad.Reader
import Control.Monad.State
-- import qualified Data.Vector as V
import Graphics.Rendering.Cairo
-- import Linear.V2
import System.Random

data World = World
  { worldWidth :: Double,
    worldHeight :: Double,
    scaleFactor :: Double
  }

-- newtype Contour = Contour (V.Vector (V2 Double))

-- contourPath :: Contour -> State Double (Generate (Render ()))
-- contourPath (Contour vertices) = sequence_ $ concat [initCmds, lines_, endCmds]
--   where
--     initCmds = [newPath, moveTo (startX) (startY)]
--     lines_ = V.toList $ V.map (\(V2 xn yn) -> lineTo xn yn) $ V.tail vertices
--     endCmds = [closePath]
--     V2 startX startY = V.head vertices

type Generate a = StateT StdGen (Reader World) a

runGenerate :: World -> StdGen -> Generate a -> a
runGenerate world rng =
  flip runReader world . fmap fst . flip runStateT rng 

bg :: Generate (Render ())
bg = do
  (World w h _) <- ask
  return $ do
    setSourceRGBA 0 0 0 1
    rectangle 0 0 w h
    fill

-- draw :: State Double (Generate (Render ()))
-- draw = do
--   (World w h _) <- ask
--   red <- state $ uniformR (0, 1)
--   green <- state $ uniformR (0, 1)
--   blue <- state $ uniformR (0, 1)
--   return $ do
--     setSourceRGBA red green blue 1
--     contourPath $ Contour $ V.fromList [V2 (w / 6) (h / 2), V2 (w / 6) (h / 4), V2 (5 * w / 6) (h / 4), V2 (5 * w / 6) (h / 2)]
--     fill

-- The animated state is the red channel, which gradually increases
-- and wraps around after hitting 1.
drawSquare :: State Double (Generate (Render ()))
drawSquare = do
  blue <- get
  if blue >= 1
    then put 0
    else put $ blue + 0.01
  return $ do
    (World w h _) <- ask
    red <- state $ uniformR (0, 1)
    green <- state $ uniformR (0, 1)
    return $ do
      setSourceRGBA red green blue 1
      rectangle (w / 4) (h / 4) (w / 2) (h / 2)
      fill

sketch :: State Double (Generate (Render ()))
sketch = do
  drawSquare_ <- drawSquare
  return $ do
    rs <- sequence [bg, drawSquare_]
    return $ sequence_ rs

animation :: Int -> State Double [Generate (Render ())]
animation frames = mapM (const $ sketch) [1 .. frames]

writeSketch :: World -> StdGen -> String -> Generate (Render ()) -> IO ()
writeSketch world rng filepath sketchs = do
  surface <- createImageSurface FormatARGB32 (round $ worldWidth world) (round $ worldHeight world)
  renderWith surface $ do
    scale (scaleFactor world) (scaleFactor world)
    runGenerate world rng sketchs
  surfaceWriteToPNG surface filepath

main :: IO ()
main = do
  let world = World 600 600 1
  let frames = 100
  let frameRenders = evalState (animation frames) 1
  rng <- initStdGen
  let filenames = map (\i -> show i ++ ".png") [1 .. frames]
  mapM_ (uncurry $ writeSketch world rng) $ zip filenames frameRenders