{-# LANGUAGE OverloadedStrings #-}
module Web.View where

import Web.Views.Home
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

main :: IO ()
main =
    do ref <- newIORef 0
       spockCfg <- defaultSpockCfg EmptySession PCNoDatabase (DummyAppState ref)
       runSpock 8080 (spock spockCfg app)

blaze :: MonadIO m => Html -> ActionCtxT ctx m a
blaze = lazyBytes . renderHtml
{-# INLINE blaze #-}

app :: SpockM () MySession MyAppState ()
app =
      do get root $
             blaze $ viewHome
