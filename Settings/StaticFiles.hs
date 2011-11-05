{-# LANGUAGE CPP, QuasiQuotes, TemplateHaskell, TypeFamilies #-}
module Settings.StaticFiles where

import Yesod.Static (staticFiles, StaticRoute (StaticRoute))
import qualified Yesod.Static as Static

static =
#if PRODUCTION
  Static.static
#else
  Static.staticDevel
#endif

staticFiles "static"
