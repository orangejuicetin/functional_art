{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE RecordWildCards #-}

module Colour (setColour) where

import Data.Colour
import Data.Colour.RGBSpace
import Data.Colour.SRGB
import Graphics.Rendering.Cairo

class CairoColour d where
  withColour :: d -> (Pattern -> Render ()) -> Render ()

instance CairoColour (Colour Double) where
  withColour col = withRGBPattern channelRed channelGreen channelBlue
    where
      -- RGB {channelRed = channelRed, channelBlue = channelBlue, channelGreen = channelGreen} = toSRGB col
      RGB {..} = toSRGB col

setColour :: (CairoColour c) => c -> Render ()
setColour col = withColour col $ \pattern -> setSource pattern