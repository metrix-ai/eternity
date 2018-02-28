module Eternity.Foldl.General
where

import Eternity.Prelude hiding (maximum)
import Control.Foldl
import qualified Data.Attoparsec.Text as B


parsing :: B.Parser parsed -> Fold (Either Text parsed) folded -> Fold Text folded
parsing parser =
  premap (bimap fromString id . B.parseOnly parser)

ignoringLeft :: Fold right folded -> Fold (Either left right) folded
ignoringLeft (Fold rightProgress rightStart rightStop) =
  Fold progress rightStart rightStop
  where
    progress !state =
      \ case
        Right right -> rightProgress state right
        Left _ -> state
