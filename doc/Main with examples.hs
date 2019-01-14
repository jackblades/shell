{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE FlexibleContexts #-}

module Main where

import Foundation
import System.Environment (getArgs)
import Web.Scotty
import Shelltree (ops)
import qualified Data.Map as M (lookup)
import           Data.Acid
-- import           Data.SafeCopy
import           Data.Typeable


args :: IO [Text]
args = fmap (fmap conv) getArgs

main :: IO ()
main = moduleMain ops

scottyMain :: IO ()
scottyMain = scotty 4000 $
    Web.Scotty.get "/:word" $ do
        beam <- param "word"
        html $ ["<h1>Scotty, ", beam, " me up!</h1>"] ^. folded

        -- http://adit.io/posts/2013-04-15-making-a-website-with-haskell.html
        -- https://github.com/scotty-web/scotty/wiki/Scotty-Tutorials-&-Examples
        
moduleMain :: Map Text (IO b) -> IO b
moduleMain ops = do
    args >>= \case
        (method:_) -> case M.lookup method ops of
            Nothing -> error $ "Method <" <> conv method <> "> not found."
            Just a -> a
        otherwise -> error $ "No method specified."


--
type ARIO e s a = RIO e ()




