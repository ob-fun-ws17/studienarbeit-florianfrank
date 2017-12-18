module Model.Config where

import Web.Spock
import Web.Spock.Config
import Web.Spock hiding (SessionId)
import qualified Data.Text as T
import           Database.Persist        hiding (get) -- To avoid a naming clash with Web.Spock.get
import qualified Database.Persist        as P         -- We'll be using P.get later for GET /people/<id>.
import           Database.Persist.Sqlite hiding (get)

data State
   = State
   { bs_cfg :: Config
   }

data Config
   = Config
   { db_name   :: T.Text
   , app_port :: Int
   }

type SessionVal = Maybe SessionId
type Api ctx = SpockCtxM ctx SqlBackend SessionVal State ()
type ApiAction ctx a = SpockActionCtx ctx SqlBackend SessionVal State a
