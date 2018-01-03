-- | Module contains data to cofigure database and REST service
module Model.Config where

import Web.Spock
import Web.Spock.Config
import Web.Spock hiding (SessionId)
import qualified Data.Text as T
import           Database.Persist        hiding (get) -- To avoid a naming clash with Web.Spock.get
import qualified Database.Persist        as P         -- We'll be using P.get later for GET /people/<id>.
import           Database.Persist.Sqlite hiding (get)

-- | Spock state
data State
   = State
   { bs_cfg :: Config   -- ^ config object
   }

-- | config data contains port and dbname
data Config
   = Config
   { db_name   :: T.Text    -- ^ db name
   , app_port :: Int        -- ^ port default 8080
   }

-- | Spock session
type SessionVal = Maybe SessionId

-- | Spock api
type Api ctx = SpockCtxM ctx SqlBackend SessionVal State ()

-- | Spock API action
type ApiAction ctx a = SpockActionCtx ctx SqlBackend SessionVal State a
