

module Shell (module X, module Shell) where
    
import Shell.Utils as X
import Turtle as X hiding ((</>), (<>), text)
import Foundation as X hiding 
    -- conflicts with turtle
    ( stdout
    , view
    , FilePath
    , Fold
    , stderr
    , stdin
    , wait
    , fold
    , contains
    , has
    , noneOf
    , strict
    , (<.>)
    -- conflicts with Control.Foldl
    , mconcat
    , find
    , nub
    )

-- import qualified Foundation as F
-- import qualified Turtle as T

