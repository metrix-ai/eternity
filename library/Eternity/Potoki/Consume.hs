module Eternity.Potoki.Consume where

import           Eternity.Prelude        hiding ( fold )
import           Potoki.Consume
import qualified Eternity.IO.FileNames         as D
import qualified Potoki.Cereal.Transform       as E


{-|
Write the events in a file in the specified directory, overwriting it if it already exists.

If any file IO error appears, Consume returns it wrapped in Left.
-}
writeToFile
  :: Serialize event
  => Bool -- ^ on `True` stream will be flushed on each event, on `False` buffering will be enabled
  -> FilePath
  -> Consume event (Either IOException ())
writeToFile flushOnEachEvent =
  let consumer = if flushOnEachEvent then writeBytesToFileWithoutBuffering else writeBytesToFile
  in  transform E.encode . consumer

{-|
Write the events to a new file in the specified directory.

If any file IO error appears, Consume returns it wrapped in Left.
-}
writeToDir
  :: Serialize event
  => Bool -- ^ on `True` stream will be flushed on each event, on `False` buffering will be enabled
  -> FilePath
  -> Consume event (Either IOException ())
writeToDir flushOnEachEvent path =
  let consumer = if flushOnEachEvent then writeBytesToFileWithoutBuffering else writeBytesToFile
  in  liftIO (D.determineNextEventFilePath path)
      >>= traverse (transform E.encode . consumer)
      >>= return
      .   join
