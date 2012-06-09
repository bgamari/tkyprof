{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module TKYProf.Controller
  ( module X
  , TKYProf(..)
  ) where
import Yesod.Core
import Yesod.Default.Handlers (getFaviconR, getRobotsR)

import TKYProf.Controller.Internal
import TKYProf.Controller.Home as X
import TKYProf.Controller.Project as X
import TKYProf.Controller.TimeAllocReport as X
import TKYProf.Controller.HeapReport as X
import TKYProf.Controller.EventReport as X

mkYesodDispatch "TKYProf" resourcesTKYProf
