{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE FlexibleContexts #-}


module Metal where

import Foundation
import System.Environment (getArgs)
import qualified Data.Map as M (lookup)

import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.Text (renderHtml)

main :: IO ()
main = runRSMXT test 3 2 >> return ()

-- MTL
newtype RSMXT e s m x a 
    = RSMXT { runRSMXT :: e -> s -> m (Either x (s, a)) }
    deriving (Functor)

instance Monad m => Applicative (RSMXT e s m x) where
    -- pure :: a -> f a
    pure a =
        RSMXT $ \e s -> pure $ Right (s, a)

    -- (<*>) :: f (a -> b) -> f a -> f b
    f <*> a = RSMXT $ \e s -> do
        runRSMXT f e s >>= \case
            Left  x -> return $ Left x
            Right (s', f') -> runRSMXT (fmap f' a) e s'

instance Monad m => Monad (RSMXT e s m x) where
    return = pure

    ma >>= f = RSMXT $ \e s -> do
        runRSMXT ma e s >>= \case
            Left  x -> return $ Left x
            Right (s', a) -> runRSMXT (f a) e s'

instance Monad m => MonadState s (RSMXT e s m x) where
    get = RSMXT $ \_ s -> return $ Right (s, s)
    put s = RSMXT $ \_ _ -> return $ Right (s, ())

instance Monad m => MonadReader e (RSMXT e s m x) where
    ask = RSMXT $ \e s -> return $ Right (s, e)
    
    -- local :: (r -> r) -> m a -> m a
    local f ma = RSMXT $ \e s -> runRSMXT ma (f e) s

class Monad m => MonadException x m | m -> x where
    throw :: x -> m a
    catch :: m a -> (x -> m a) -> m a

instance Monad m => MonadException x (RSMXT e s m x) where
    throw x = RSMXT $ \_ _ -> return $ Left x
    catch ma f = RSMXT $ \e s ->  -- TODO
        runRSMXT ma e s >>= \case
            Left x -> return $ Left x
            Right a -> return $ Right a

instance MonadIO m => MonadIO (RSMXT e s m x) where
    -- liftIO :: IO a -> m a
    liftIO io = RSMXT $ \_ s -> liftIO $ fmap (Right . (,) s) io

-- test :: RSMXT Int Int IO Int Int
-- test :: Monad m => RSMXT Int (Int, Int) m Int Int
test :: ( Show e
        , MonadReader e m
        , MonadState Int m
        , MonadException Int m
        , MonadIO m)
        => m Int
test = do
    x <- get
    y <- ask
    
    liftIO $ putStrLn (show y)
    throw (3 :: Int) 
        `Metal.catch` \y -> put y
    
    return x


