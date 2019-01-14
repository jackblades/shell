{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell    #-}
{-# LANGUAGE TypeFamilies       #-}

module Acid (main) where

import           Prelude (Show, show, putStrLn, unwords)
import           Foundation
import           Control.Monad.Reader
import           Control.Monad.State
import           Data.Acid
import           Data.SafeCopy
import           Data.Typeable
import           System.Environment (getArgs)


------------------------------------------------------
-- The Haskell structure that we want to encapsulate

data HelloWorldState = HelloWorldState Text
    deriving (Show, Typeable)

$(deriveSafeCopy 0 'base ''HelloWorldState)

------------------------------------------------------
-- The transaction we will execute over the state.

writeState :: Text -> Update HelloWorldState ()
writeState newValue
    = put (HelloWorldState newValue)

queryState :: Query HelloWorldState Text
queryState = do HelloWorldState string <- ask
                return string

$(makeAcidic ''HelloWorldState ['writeState, 'queryState])

------------------------------------------------------
-- This is how AcidState is used:

main :: IO ()
main = do acid <- openLocalState (HelloWorldState "Hello world")
          args <- getArgs
          if null args
             then do string <- query acid QueryState
                     putStrLn $ "The state is: " ++ conv string
             else do update acid (WriteState (conv $ unwords args))
                     putStrLn "The state has been modified!"