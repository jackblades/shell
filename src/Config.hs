{-# LANGUAGE TemplateHaskell #-}

module Config where

import RIO
import Foundation.Utils

data Config = Config
    { _rootDir :: FilePath

    }

-- makeLenses ''Config

shellConfigDefault :: Config
shellConfigDefault = Config
    { _rootDir = "/quasar-store"

    }