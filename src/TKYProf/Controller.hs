{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module TKYProf.Controller where
import Yesod.Core
import Yesod.Default.Handlers (getFaviconR, getRobotsR)

import TKYProf.Controller.Internal
import TKYProf.Controller.Home
import TKYProf.Controller.Project
import TKYProf.Controller.TimeAllocReport
import TKYProf.Controller.HeapReport
import TKYProf.Controller.EventReport

mkYesodDispatch "TKYProf" $(parseRoutesFile "config/routes2")
