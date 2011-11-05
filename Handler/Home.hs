{-# LANGUAGE TemplateHaskell, QuasiQuotes, OverloadedStrings #-}
module Handler.Home where
import Data.Maybe (listToMaybe)
import Foundation hiding (reports)
import Handler.Reports.Helpers (getAllReports)
import ProfilingReport (ProfilingReport(..))
import Yesod.Form (Enctype(Multipart))

getHomeR :: Handler RepHtml
getHomeR = do
  reports <- getAllReports
  defaultLayout $ do
    setTitle "TKYProf"
    addScript $ StaticR js_jquery_ui_widget_js
    addScript $ StaticR js_jquery_iframe_transport_js
    addScript $ StaticR js_jquery_fileupload_js
    $(widgetFile "home")
