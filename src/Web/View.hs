{-# LANGUAGE OverloadedStrings #-}
module Web.View where

import Model.Member
import Web.Views.Home
import Web.Views.AppointmentManagement
import Web.Views.MemberManagement
import Web.Views.Impressum
import Web.Views.Logout

import Web.Spock
import Web.Spock.Config
import Web.Spock hiding (SessionId)

import Control.Monad.Trans
import Data.Monoid
import Network.Wai.Middleware.Static
import Text.Blaze.Html (Html, toHtml)
import Text.Blaze.Html.Renderer.Utf8 (renderHtml)
import Data.IORef
import qualified Data.Text as T

data MySession = EmptySession
data MyAppState = DummyAppState (IORef Int)

init_view :: IO ()
init_view =
    do ref <- newIORef 0
       spockCfg <- defaultSpockCfg EmptySession PCNoDatabase (DummyAppState ref)
       runSpock 8080 (spock spockCfg app)

blaze :: MonadIO m => Html -> ActionCtxT ctx m a
blaze = lazyBytes . renderHtml
{-# INLINE blaze #-}

app :: SpockM () MySession MyAppState ()
app =
    do middleware (staticPolicy (addBase "static"))
       get root $
            blaze $ viewHome
       get "/home" $
            blaze $ viewHome
       get "/membermanagement" $
            blaze $ viewMemberManagement testMembers
       get "/appointmentmanagement" $
            blaze $ viewAppointments
       get "/logout" $
            blaze $ viewLogout
       get "/impressum" $
            blaze $ viewImpressum
