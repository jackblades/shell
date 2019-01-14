
module Foundation (module X, module Foundation) where

import Data.Text.IO as X
import qualified RIO as RIO
import RIO as X hiding 
    ( String
    , show
    -- potentially useless
    , forM
    , forM_
    , mapM
    , mapM_
    , sequence
    , sequence_
    , msum
    -- confilct with Control.Lens
    , ASetter
    , ASetter'
    , Getting
    , Lens
    , Lens'
    , lens
    , view
    , (<&>)
    , (^.)
    , over
    , set
    , to
    , sets
    -- conflict with Control.Foldl
    -- , Handler
    -- , Vector
    -- , Fold
    -- , Fold
    -- , mconcat
    -- , map
    -- , length
    -- , all
    -- , any
    -- , index
    -- , null
    -- , foldM
    -- , and
    -- , mapM_
    -- , notElem
    -- , or
    -- , lookup
    -- , set
    -- , elem
    -- , fold
    -- , foldMap
    -- , product
    -- , sum
    -- , folded
    -- , filtered
    -- remove all string functions
    , words
    , unwords
    , lines
    , unlines
    )
import RIO.Char as X
import RIO.Time as X
import Data.Hashable as X (hash)
import Text.Pretty.Simple as X (pPrint)

import RIO.State as X (MonadState(..))
import Control.Monad.ST as X (ST(..), fixST, runST,)
import Data.STRef as X (STRef, newSTRef, readSTRef, writeSTRef, modifySTRef, modifySTRef')

-- import Control.Concurrent.STM as X
-- import Control.Monad.STM as X

import Control.Lens as X
import Data.Data.Lens as X
import Data.Text.Lens as X

import Conduit as X

import Foundation.Utils as X
import Data.FileEmbed as X

import Data.Dynamic as X (Dynamic)
import Data.Dynamic.Lens as X

import Data.Text (pack)



-- import Data.List as X (foldl')
-- import Data.Foldable as X hiding (find, fold)
-- import Data.Traversable as X

-- import Control.Foldl as X hiding  -- lens possibly takes care of all of it's use case
--     ( Fold
--     , index
--     , set
--     , folded
--     , filtered
--     )

-- import Control.Arrow as X ((&&&), (|||), (<<<), (>>>))

-- import Data.Text as X hiding
--     -- conflicts with RIO, RIO.Char, and Control.Lens
--     ( all
--     , any
--     , concat
--     , concatMap
--     , lines
--     , unlines
--     , unwords
--     , words
--     , break
--     , drop
--     , dropWhile
--     , replicate
--     , reverse
--     , span
--     , take
--     , takeWhile
--     , foldl'
--     , foldr
--     , length
--     , null
--     , filter
--     , map
--     , zip
--     , index
--     , cons
--     , snoc
--     , toLower
--     , toTitle
--     , toUpper
--     , uncons
--     , unsnoc
--     )
-- import Data.Map as X hiding
--     ( foldl
--     , split
--     , mapMaybe
--     , drop
--     , lookup
--     , take
--     , fold
--     , foldl'
--     , foldr
--     , null
--     , toList
--     , filter
--     , map
--     , empty
--     , findIndex
--     , singleton
--     , partition
--     , splitAt
--     )