{-# LANGUAGE CPP, QuasiQuotes, TemplateHaskell, TypeFamilies #-}
module Settings.StaticFiles where

import Yesod.Static
import qualified Yesod.Static as Static

static :: FilePath -> IO Static.Static
static =
#if PRODUCTION
  Static.static
#else
  Static.staticDevel
#endif

staticFiles "static"
