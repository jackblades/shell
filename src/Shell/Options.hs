module Shell.Options where

--
import Foundation
import Options.Applicative

data ShellOptions 
    = Parse
    | ParseFile FilePath
     