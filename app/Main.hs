{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE FlexibleContexts #-}

module Main where

import Foundation
import System.Environment (getArgs)
import Web.Scotty
import qualified Data.Map as M (lookup)

import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.Text (renderHtml)

main :: IO ()
main = scotty 7001 $
    Web.Scotty.get "/:word" $ do
        -- beam <- param "word"
        Web.Scotty.html $ renderHtml tree

        -- http://adit.io/posts/2013-04-15-making-a-website-with-haskell.html
        -- https://github.com/scotty-web/scotty/wiki/Scotty-Tutorials-&-Examples

tree = H.docTypeHtml $ do
    H.head $ do
        H.title "tree example"
        H.style ! A.type_ "text/css" $ treeCss
        H.script ! A.type_ "text/javascript" $ treeToggleJs

    H.body $ H.pre $ do
        treeNode 0 "0" (treeLeaf 0 "1" "1") $ do
            treeLeaf 1 "2" "2"
            treeLeaf 1 "3" "3"
            treeLeaf 1 "4" "4"
            
-- tree utils
treeLeaf i d x = do
    H.span ! A.id ("node" <> d)
           ! A.class_ "node fixed" 
           $ H.text (prefix <> x)
    H.br
    where prefix = mconcat (replicate i " │ ") <> " ├╴" 
treeNode i d x xs = do
    let prefix = if i==0 then "" else mconcat (replicate i " │ ") <> " ├╴" 
    H.span ! A.id ("node" <> d) 
           ! class_ "node interactive expanded"
           ! onclick "toggle(event)"
           $ H.text prefix >> x 
    H.span ! A.id ("children_node" <> d) ! class_ "shown" $ xs
    H.br

-- external files
convt x = conv x :: Text

treeCss = toHtml . convt $ $(embedFile "assets/css/tree.css")
treeToggleJs = toHtml . convt $ $(embedFile "assets/js/treeToggle.js")
