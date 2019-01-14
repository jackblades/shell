{-# LANGUAGE FlexibleContexts #-}

module Shelltree where

import Shell
import qualified Data.Text as T
import qualified Data.ByteString as BS
import qualified Data.Map.Strict as M

-- ops interface

currentDirectory = "." :: Text

ops :: M.Map Text (IO ())
ops = dict
  [ "explore"               ==> ph $ explore currentDirectory
  , "selectFile"            ==> ph $ selectFile currentDirectory
  , "explorePreview"        ==> arguments >>= pPrint -- explorePreview . last
  , "treePreview"           ==> arguments >>= explorePreview . conv . (^?! element 4)
  ] where ph s = sh $ s >>= echo



-- package operations
newpkg name = do
    let nameFP = conv name
    testdir nameFP >>= \case
        True -> err . conv
            $ "Unable to create package: " <> name <> ". Path already exists."
        False -> do
            mktree nameFP
            output (qsrFile name) $ 
                return assetQsrFile

delpkg name = do
    testfile (qsrFile name) >>= \case
        False -> err $ conv $ "Not a quasar package: " <> name
        True  -> rmtree $ conv name

explore pkg =
    fzfpm fpreview $ tree2 pkg
    where fpreview = stackExec "explorePreview"

selectFile pkg =
    fzfpm fpreview $ tree2 pkg 
    where fpreview = stackExec "treePreview"

-- preview functions
explorePreview path = do
    testfile path >>= \case
        True -> stdout $ input path
        False -> view $ ls path


-- constants and utility
qsrFile pkg = conv $ [pkg, "/", pkg, ".quasar"] ^. folded
stackExec f = "stack exec shell-exe -- " <> f <> " '{}'"

assetQsrFile = conv $(embedFile "assets/package.quasar")

tree2 :: Text -> Shell Line
tree2 = go 0 . conv where
    go indent dir = do
        let spaces = 
                conv $ replicate (indent * 4) ' '
            fname = 
                conv (filename dir)
            chash name = 
                conv 
                $ (+) 1009 
                $ flip mod 7919 
                $ hash (conv dir :: Text)
            line sym name = 
                mconcat [" [", chash name, "] ", spaces, sym, " ", name]
        
        testfile dir >>= \case
            True  -> return $ line "-" fname
            False -> return (line "+" $ conv dir)
                 <|> (ls dir >>= go (indent + 1))


