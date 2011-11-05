{-# LANGUAGE QuasiQuotes, CPP, TemplateHaskell, OverloadedStrings #-}
module Settings
  ( widgetFile
  , staticRoot
  , staticDir
  ) where

import Control.Monad (join)
import Data.Monoid (mempty)
import Data.Object
import Data.Text (Text, pack)
import Language.Haskell.TH.Syntax
import System.Directory (doesFileExist)
import Text.Shakespeare.Text (st)
import Yesod.Widget (addWidget, addJulius, addLucius, whamletFile)
import qualified Data.Object.Yaml as YAML
import qualified Text.Hamlet as S
import qualified Text.Julius as S
import qualified Text.Lucius as S
import qualified Text.Shakespeare.Text as S
import Yesod.Default.Config (AppConfig, DefaultEnv)
import Yesod.Default.Util (widgetFileProduction, widgetFileDebug)
import Yesod.Config (appRoot)

staticDir :: FilePath
staticDir = "static"

staticRoot :: AppConfig DefaultEnv -> Text
staticRoot conf = [st|#{appRoot conf}/static|]

widgetFile :: String -> Q Exp
#if PRODUCTION
widgetFile = widgetFileProduction
#else
widgetFile = widgetFileDebug
#endif
