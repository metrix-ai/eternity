module Eternity.Attoparsec.FileNames
where

import Eternity.Prelude
import Data.Attoparsec.Text


eventsFileName :: Parser Int
eventsFileName =
  do
    index <- decimal
    string ".events"
    return index
