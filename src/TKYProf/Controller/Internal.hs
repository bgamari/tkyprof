{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
module TKYProf.Controller.Internal where
import Control.Applicative ((<$>), (<*>))
import Data.Char (toLower)
import Data.List (stripPrefix)
import Data.Maybe (fromMaybe)
import Data.Monoid ((<>))
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified Data.Text.Encoding.Error as TEE

import Data.Aeson ((.=))
import qualified Data.Aeson as A
import qualified Data.Attoparsec.Text as AT
import Database.Persist.GenericSql (ConnectionPool, SqlPersist, runSqlPool)
import qualified Network.Wai as W
import Text.Hamlet (hamletFile)
import Text.Jasmine (minifym)
import Yesod.Core
import Yesod.Default.Config (AppConfig(..), DefaultEnv)
import Yesod.Default.Util (addStaticContentExternal)
import Yesod.Json (jsonToRepJson)
import Yesod.Logger (Logger, logLazyText)
import Yesod.Persist
import Yesod.Static (Static, Route(StaticRoute), base64md5)

import TKYProf.Model

import Settings (widgetFile)
import qualified Settings
import Settings.StaticFiles

data TKYProf = TKYProf
  { tkyConfig   :: AppConfig DefaultEnv ()
  , tkyLogger   :: Logger
  , tkyStatic   :: Static
  , tkyConnPool :: ConnectionPool
  }

mkYesodData "TKYProf" $(parseRoutesFile "config/routes2")

instance Yesod TKYProf where
  approot = ApprootRelative

  -- | errorHandler supports JSON format as well as HTML format
  errorHandler errResp = do
    htmlChooseRep <- defaultErrorHandler errResp
    RepJson jsonContent <- genJsonContent
    return $ \contentTypes -> do
      (_, htmlContent) <- htmlChooseRep contentTypes
      chooseRep (RepHtmlJson htmlContent jsonContent) contentTypes
    where
      genJsonContent = case errResp of
        NotFound -> do
          -- Copied from Yesod.Core
          r <- waiRequest
          let path = TE.decodeUtf8With TEE.lenientDecode $ W.rawPathInfo r
          jsonToRepJson $ A.object ["message" .= A.toJSON ("Path " <> path <> " is not found.")]
        PermissionDenied mesg -> do
          jsonToRepJson $ A.object ["message" .= mesg]
        InvalidArgs args -> do
          jsonToRepJson $ A.object ["message" .= T.intercalate "," args]
        InternalError err -> do
          jsonToRepJson $ A.object ["message" .= err]
        BadMethod method -> do
          jsonToRepJson $ A.object ["message" .= A.toJSON ("Method " <> method <> " is not supported.")]

  defaultLayout widget = do
    mmsg <- getMessage
    (title, bcs) <- breadcrumbs
    pc <- widgetToPageContent $ do
      -- $(widgetFile "normalize")
      $(widgetFile "header")
      $(widgetFile "default-layout")
    hamletToRepHtml $(hamletFile "templates/default-layout-wrapper.hamlet")

  urlRenderOverride y (StaticR s) =
    Just $ uncurry (joinPath y (Settings.staticRoot $ tkyConfig y)) $ renderRoute s
  urlRenderOverride _ _ = Nothing

  messageLogger y loc level msg =
    formatLogMessage loc level msg >>= logLazyText (tkyLogger y)

  addStaticContent =
    addStaticContentExternal minifym base64md5 Settings.staticDir (StaticR . flip StaticRoute [])

  jsLoader _ = BottomOfBody

instance YesodBreadcrumbs TKYProf where
  breadcrumb route = return $ case route of
    _                     -> ("Not found", Just HomeR)

instance YesodPersist TKYProf where
  type YesodPersistBackend TKYProf = SqlPersist
  runDB act = do
    tkyprof <- getYesod
    runSqlPool act $ tkyConnPool tkyprof

pagenator
  :: Int
  -> Int
  -> (([SelectOpt v] -> [SelectOpt v]) -> GHandler master sub a)
  -> GHandler master sub a
pagenator defOffset defLimit f = do
  offset <- fromMaybe defOffset . (>>= parseInt) <$> lookupGetParam "offset"
  limit <- fromMaybe defLimit . (>>= parseInt) <$> lookupGetParam "limit"
  f ([OffsetBy offset, LimitTo limit] ++)
  where
    parseInt :: Text -> Maybe Int
    parseInt = either (const Nothing) Just
             . AT.parseOnly AT.decimal

removePrefix :: String -> String -> String
removePrefix prefix = lower . (fromMaybe <*> stripPrefix prefix)
  where
    lower :: String -> String
    lower []     = []
    lower (x:xs) = toLower x:xs
