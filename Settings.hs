{-# LANGUAGE QuasiQuotes, CPP, TemplateHaskell, OverloadedStrings #-}
-- | Settings are centralized, as much as possible, into this file. This
-- includes database connection settings, static file locations, etc.
-- In addition, you can configure a number of different aspects of Yesod
-- by overriding methods in the Yesod typeclass. That instance is
-- declared in the tkyprof.hs file.
module Settings
  ( hamletFile
  , juliusFile
  , luciusFile
  , widgetFile
  , staticRoot
  , staticDir
  , loadConfig
  , AppEnvironment(..)
  , AppConfig(..)
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

data AppEnvironment
  = Test
  | Development
  | Staging
  | Production
  deriving (Eq, Show, Read, Enum, Bounded)

data AppConfig = AppConfig
  { appEnv :: AppEnvironment
  , appPort :: Int
  , appRoot :: Text
  } deriving Show

loadConfig :: FilePath -> AppEnvironment -> IO AppConfig
loadConfig conf env = do
  allSettings <- (join $ YAML.decodeFile conf) >>= fromMapping
  settings <- lookupMapping (show env) allSettings
  hostS <- lookupScalar "host" settings
  port <- fmap read $ lookupScalar "port" settings
  return AppConfig { appEnv  = env
                   , appPort = port
                   , appRoot = pack $ hostS ++ appPort port
                   }
    where appPort :: Int -> String
#ifdef PRODUCTION
          appPort _ = ""
#else
          appPort p = ":" ++ show p
#endif

-- | The location of static files on your system. This is a file system
-- path. The default value works properly with your scaffolded site.
staticDir :: FilePath
staticDir = "static"

-- | The base URL for your static files. As you can see by the default
-- value, this can simply be "static" appended to your application root.
-- A powerful optimization can be serving static files from a separate
-- domain name. This allows you to use a web server optimized for static
-- files, more easily set expires and cache values, and avoid possibly
-- costly transference of cookies on static files. For more information,
-- please see:
--   http://code.google.com/speed/page-speed/docs/request.html#ServeFromCookielessDomain
--
-- If you change the resource pattern for StaticR in tkyprof.hs, you will
-- have to make a corresponding change here.
--
-- To see how this value is used, see urlRenderOverride in tkyprof.hs
staticRoot :: AppConfig -> Text
staticRoot conf = [st|#{appRoot conf}/static|]

-- The rest of this file contains settings which rarely need changing by a
-- user.

-- The following three functions are used for calling HTML, CSS and
-- Javascript templates from your Haskell code. During development,
-- the "Debug" versions of these functions are used so that changes to
-- the templates are immediately reflected in an already running
-- application. When making a production compile, the non-debug version
-- is used for increased performance.
--
-- You can see an example of how to call these functions in Handler/Root.hs
--
-- Note: due to polymorphic Hamlet templates, hamletFileDebug is no longer
-- used; to get the same auto-loading effect, it is recommended that you
-- use the devel server.

globFile :: String -> String -> FilePath
globFile kind x = kind ++ "/" ++ x ++ "." ++ kind

hamletFile :: FilePath -> Q Exp
hamletFile = S.hamletFile . globFile "hamlet"

luciusFile :: FilePath -> Q Exp
luciusFile =
#ifdef PRODUCTION
  S.luciusFile . globFile "lucius"
#else
  S.luciusFileDebug . globFile "lucius"
#endif

juliusFile :: FilePath -> Q Exp
juliusFile =
#ifdef PRODUCTION
  S.juliusFile . globFile "julius"
#else
  S.juliusFileDebug . globFile "julius"
#endif

textFile :: FilePath -> Q Exp
textFile =
#ifdef PRODUCTION
  S.textFile . globFile "text"
#else
  S.textFileDebug . globFile "text"
#endif

widgetFile :: FilePath -> Q Exp
widgetFile x = do
  let h = whenExists (globFile "hamlet") (whamletFile . globFile "hamlet")
  let j = whenExists (globFile "julius")  juliusFile
  let l = whenExists (globFile "lucius") luciusFile
  [|addWidget $h >> addJulius $j >> addLucius $l|]
  where
    whenExists tofn f = do
      e <- qRunIO $ doesFileExist $ tofn x
      if e then f x else [|mempty|]
