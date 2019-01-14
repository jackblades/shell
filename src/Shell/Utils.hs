{-# LANGUAGE FlexibleContexts #-}

module Shell.Utils where

import RIO hiding ((<>))
import Turtle 
import Foundation.Utils
import Foundation.Log

-- [DESIGN] ALL DIRECT CALLS TO SYSTEM SHOULD BE HERE
-- fzf
fzf = inshell ("fzf" <> fzfOpts)
fzfm = inshell ("fzf" <> fzfmOpts)
fzfp cmd = inshell ("fzf" <> fzfOpts <> " --preview=\"" <> cmd <> "\"") 
fzfpm cmd = inshell ("fzf" <> fzfmOpts <> " --preview=\"" <> cmd <> "\"") 
  -- fzf options
fzfOpts = " --reverse" <> " --ansi"
fzfmOpts = fzfOpts <> " --multi"


-- basic cli commands
tree path = inshell ("tree -f -L 2 " <> path) empty
  -- get the node string from tree's output
extractElementTree e = inshell perlTreeExtractPattern $ return e where
    perlTreeExtractPattern = "perl -ne '/─ (.*)$/; print \"$1\"'"


-- basic primitives
hrule :: Shell Line
hrule = pure $ conv (replicate 60 '-')

lsByTime path = inproc "/bin/ls" ["-tu", path] empty

mkcd dirname = do
    ifNotExists dirname $ 
        mktree dirname
    cd dirname

-- even more basic primitivies
ifNotExists path f = do
    exists <- testpath path
    if exists 
    then logError $ conv ("directory exists: " <> conv path :: Text)
    else f

pipe []       = empty
pipe (c:cmds) = c $ pipe cmds 
    
    