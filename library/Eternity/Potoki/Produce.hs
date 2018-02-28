module Eternity.Potoki.Produce
where

import Eternity.Prelude
import Potoki.Produce
import qualified Potoki.Cereal.Transform as E
import qualified Potoki.Transform as A
import qualified Potoki.IO as B
import qualified Potoki.Consume as C


{-|
Read events from a file.
-}
readFromFile :: Serialize event => FilePath -> Produce (Either IOException (Either Text event))
readFromFile path =
  transform (right E.decode) (fileBytes path)

{-|
Read events from a directory, which has been populated with 'Eternity.Potoki.Consume.writeToDir'.
-}
readFromDir :: Serialize event => FilePath -> Produce (Either IOException (Either Text event))
readFromDir dirPath =
  transform
    (right (A.produce readFromFile) >>^ either Left id)
    (directoryContents dirPath)
  where
    readFromFileTransform =
      A.produce readFromFile
