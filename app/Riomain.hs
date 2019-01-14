
{-# LANGUAGE NoImplicitPrelude #-}
-- | Provide a @SimpleApp2@ datatype, for providing a basic @App@-like
-- environment with common functionality built in. This is intended to
-- make it easier to, e.g., use rio's logging and process code from
-- within short scripts.
--
-- @since 0.1.3.0
module Riomain
  ( SimpleApp2
  , runSimpleApp2
  ) where

-- import RIO.Prelude.Reexports
-- import RIO.Prelude.Logger
-- import RIO.Prelude.Lens
-- import RIO.Prelude.RIO
import Foundation
import RIO.Process
import System.Environment (lookupEnv)

-- | A simple, non-customizable environment type for @RIO@, which
-- provides common functionality. If it's insufficient for your needs,
-- define your own, custom @App@ data type.
--
-- @since 0.1.3.0
data SimpleApp2 = SimpleApp2
  { saLogFunc :: !LogFunc
  , saProcessContext :: !ProcessContext
  }
instance HasLogFunc SimpleApp2 where
  logFuncL = lens saLogFunc (\x y -> x { saLogFunc = y })
instance HasProcessContext SimpleApp2 where
  processContextL = lens saProcessContext (\x y -> x { saProcessContext = y })

-- | Run with a default configured @SimpleApp2@, consisting of:
--
-- * Logging to stderr
--
-- * If the @RIO_VERBOSE@ environment variable is set, turns on
--   verbose logging
--
-- * Default process context
--
-- @since 0.1.3.0
runSimpleApp2 :: MonadIO m => RIO SimpleApp2 a -> m a
runSimpleApp2 m = liftIO $ do
    verbose <- isJust <$> lookupEnv "RIO_VERBOSE"
    lo <- logOptionsHandle stderr verbose
    pc <- mkDefaultProcessContext
    withLogFunc lo $ \lf ->
        let simpleApp2 = SimpleApp2
                { saLogFunc = lf
                , saProcessContext = pc
                }
        in runRIO simpleApp2 m