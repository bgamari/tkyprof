{-# LANGUAGE QuasiQuotes, CPP, TemplateHaskell, OverloadedStrings #-}
module Settings
  ( widgetFile
  , staticRoot
  , staticDir
  ) where

import Data.Text (Text)
import Language.Haskell.TH.Syntax
import Text.Shakespeare.Text (st)
import Yesod.Default.Config (AppConfig(..), DefaultEnv)
import Yesod.Default.Util (widgetFileNoReload, widgetFileReload)

staticDir :: FilePath
staticDir = "static"

staticRoot :: AppConfig DefaultEnv extra -> Text
staticRoot conf = [st|#{appRoot conf}/static|]

widgetFile :: String -> Q Exp
#if PRODUCTION
widgetFile = widgetFileNoReload
#else
widgetFile = widgetFileReload
#endif
