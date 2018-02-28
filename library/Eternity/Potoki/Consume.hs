module Eternity.Potoki.Consume
where

import Eternity.Prelude hiding (fold)
import Potoki.Consume
import qualified Eternity.IO.FileNames as D
import qualified Potoki.Cereal.Transform as E


{-|
Write the events in a file in the specified directory, overwriting it if it already exists.

If any file IO error appears, Consume returns it wrapped in Left.
-}
writeToFile :: Serialize event => FilePath -> Consume event (Either IOException ())
writeToFile =
  transform E.encode . writeBytesToFile

{-|
Write the events to a new file in the specified directory.

If any file IO error appears, Consume returns it wrapped in Left.
-}
writeToDir :: Serialize event => FilePath -> Consume event (Either IOException ())
writeToDir path =
  liftIO (D.determineNextEventFilePath path) >>=
  traverse (transform E.encode . writeBytesToFile) >>=
  return . join
