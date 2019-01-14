{-# LANGUAGE LambdaCase #-}

module IDE.Module where

import Shell

data Visibility = PUBLIC | PRIVATE deriving (Eq, Show)
type Tmap v = Map Text v
type Textmap = Map Text Text
type Textset = Set Text

data Import
    = Import Text Text  -- import X; import X as Y
    | ImportAll Text Textset  -- from X import * except a, b, c
    | ImportFrom Text Textmap  -- from X import a, b, c as c'
    deriving (Show)

data Module expr
    = Leaf {
        _name :: Text,
        _visibility :: Visibility,
        _imports :: [Import],
        _expr :: expr
    }
    | Node {
        _name :: Text,
        _visibility :: Visibility,
        _exports :: [Text],
        _submodules :: [Module expr]
    }
    deriving (Show)

makeLenses ''Module
makePrisms ''Module

foldModule :: p -> p -> Module expr -> p
foldModule leaf node m = case m of
    Leaf _ _ _ _ -> leaf
    Node _ _ _ _ -> node

data Package expr
    = Package {
        packageName :: Text,
        depends :: [Text]        
    } deriving (Show)

-- IO code

importsx :: Module e -> [Import]
importsx m = 
    foldModule leafImports nodeImports m 
    where
        leafImports = m ^. imports
        nodeImports = m ^. submodules . traverse . to importsx

exportsx :: Module e -> [Text]
exportsx m = 
    if m ^. visibility == PUBLIC
    then foldModule leafExports nodeExports m 
    else [] where
        leafExports = [m ^. name]
        nodeExports = m ^. name : subexports
          where subexports = m ^. submodules . traverse . to exportsx
    


-- test node
l1 = Leaf "l1" PUBLIC [Import "System.IO" "SIO"] ()
l2 = Leaf "l2" PRIVATE [Import "System.ENV" "ENV"] ()
n1 = Node "n1" PUBLIC [] [l1, l2, l1]
n2 = Node "n2" PUBLIC [] [n1, l2]