module Main where

import Prelude
import Test.QuickCheck.Instances
import Test.Tasty
import Test.Tasty.Runners
import Test.Tasty.HUnit
import Test.Tasty.QuickCheck
import System.Directory
import qualified Eternity.Potoki.Produce as O
import qualified Eternity.Potoki.Consume as P
import qualified Potoki.Produce as F
import qualified Potoki.IO as G
import qualified Potoki.Consume as H


main =
  defaultMain $
  testGroup "Store and read events" $
  [
    testProperty "Store and read events" $ \ (events :: [Int]) ->
    unsafePerformIO $ do
      removePathForcibly directory
      createDirectoryIfMissing True directory
      writeEvents events
      readEventsResult <- readEvents
      return (Right (Right events) === readEventsResult)
  ]
  where
    directory =
      "dist/test-events"
    writeEvents events =
      G.produceAndConsume (F.list events) (P.writeToDir directory)
    readEvents =
      G.produceAndConsume
        (O.readFromDir directory)
        (right' (right' H.list))
