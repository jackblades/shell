{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TemplateHaskell #-}

module UImain where

import RIO hiding (ask, div)
import Data.Tree.View
import Data.Tree
import Control.Lens

import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.Text (renderHtml)



-- t = unfoldTree (\x -> (x, if x < 10 then [2*x, 2*x+1] else [])) (1 :: Int)
-- x = fmap (\x -> NodeInfo InitiallyExpanded (show x) "") t
-- z = preEscapedToHtml (htmlTree Nothing x :: String)

data Css = Css deriving (Eq, Show)
data Js = Js deriving (Eq, Show)
data Html = Html deriving (Eq, Show)
type Percent = Float
data Axis = HORIZONTAL Percent | VERTICAL Percent deriving (Eq, Show)

data Page a = Layout Axis [Page a]
            | Widget Css Js Metal.Html a
            deriving (Eq, Show, Functor)
makeLenses ''Page
makePrisms ''Page

renderPage = \case
    Layout axis pages -> case axis of
        HORIZONTAL p -> undefined
        VERTICAL   p -> undefined
    Widget css js html a -> undefined

--
instance Semigroup Css where Css <> Css = Css
instance Semigroup Js where Js <> Js = Js
instance Semigroup Metal.Html where Html <> Html = Html

-- --
-- l = Layout (HORIZONTAL 100)
--     [ Layout (VERTICAL 50)
--         [ Widget ]

--     ]






