module Eternity.IO.FileNames
where

import Eternity.Prelude
import qualified System.Directory as A
import qualified Eternity.Foldl.FileNames as B
import qualified Control.Foldl as C


determineNextEventFilePath :: FilePath -> IO (Either IOException FilePath)
determineNextEventFilePath dirPath =
  try (fmap (mappend dirPath . (:) '/' . C.fold B.nextEventFileName) (A.listDirectory dirPath))
