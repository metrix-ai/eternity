module Eternity.Foldl.FileNames
where

import Eternity.Prelude hiding (maximum)
import Control.Foldl
import Eternity.Foldl.General
import qualified Eternity.Attoparsec.FileNames as C


nextEventFileName :: Fold FilePath FilePath
nextEventFileName =
  fmap (maybe "1.events" (\ index -> showInt (succ index) ".events")) lastEventFileIndex

lastEventFileIndex :: Fold FilePath (Maybe Int)
lastEventFileIndex =
  onEventFileIndices maximum

onEventFileIndices :: Fold Int a -> Fold FilePath a
onEventFileIndices =
  premap fromString . parsing C.eventsFileName . ignoringLeft
