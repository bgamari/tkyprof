{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
module TKYProf.Controller.Home where
import Text.Coffee (coffeeFile)
import Text.Hamlet (hamletFile)
import Yesod.Core

import TKYProf.Controller.Internal

getHomeR :: Handler RepHtml
getHomeR = do
  defaultLayout $ do
    toWidget $(coffeeFile "templates/tkyprof.coffee")
    toWidget $(hamletFile "templates/home.hamlet")
