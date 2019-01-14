{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE IncoherentInstances #-}

module Foundation.Utils ((.:), dict, (==>), asText, asBytes, fmt, show, TShow, conv) where

import RIO hiding (FilePath, show)
import qualified RIO as P (show, Show)
import Data.Hashable (Hashable)
import Turtle

import Data.Text.Encoding (encodeUtf8, decodeUtf8)
import qualified Data.Text as T
import qualified Data.ByteString as BS
import qualified Data.Map as M

-- composition
(.:) :: (t1 -> t2) -> (t3 -> t4 -> t1) -> t3 -> t4 -> t2
f .: g = \ a b -> f (g a b)

-- better maps      dict [ "hello" ==> "world" ]
dict :: Ord k => [(k, v)] -> M.Map k v
dict = M.fromList

k ==> v = (k, v)
infixr 0 ==>


-- string formatting and printing
asText s = T.pack s 
asBytes s = BS.pack s

fmt :: Format Text r -> r
fmt = format

class TShow a where
    show :: a -> Text

instance TShow Text where
    show = id

instance P.Show a => TShow a where
    show = T.pack . P.show

-- string conversions
class Convertible a b where
    conv :: a -> b

instance Convertible Int Line where conv = conv . show

instance Convertible [Char] T.Text where conv = T.pack
instance Convertible [Char] Line where conv = fromString
instance Convertible [Char] FilePath where conv = decodeString

instance Convertible T.Text [Char] where conv = T.unpack
instance Convertible T.Text Line where conv = unsafeTextToLine
instance Convertible T.Text BS.ByteString where conv = encodeUtf8
instance Convertible T.Text FilePath where conv = fromText
instance Convertible T.Text Utf8Builder where conv = display

instance Convertible BS.ByteString T.Text where conv = decodeUtf8
instance Convertible BS.ByteString Line where conv = unsafeTextToLine . conv

instance Convertible Line [Char] where conv = T.unpack . conv
instance Convertible Line T.Text where conv = lineToText
instance Convertible Line FilePath where conv = fromText . conv

instance Convertible FilePath T.Text where conv = \fp -> let Right p = toText fp in p
instance Convertible FilePath Line where conv = conv . encodeString
instance Convertible FilePath String where conv = encodeString
-- instance (Functor f, Convertible a b) => Convertible (f a) (f b) where conv = fmap conv
