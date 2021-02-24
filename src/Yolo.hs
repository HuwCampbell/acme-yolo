{-# LANGUAGE FlexibleContexts       #-}
{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE UndecidableInstances   #-}
module Yolo where

import Data.Default (Default (..))

import GHC.Stack
import System.IO.Unsafe

import Text.Show.Pretty

import Data.These (These (..))

import Control.Monad.Trans.Cont (ContT (..), evalContT)

import Control.Monad.Identity (Identity (..))
import Control.Monad.Trans.Except
import Control.Monad.Trans.Identity
import Control.Monad.Trans.Maybe
import Control.Monad.Trans.Reader
import Control.Monad.Trans.Resource
import Control.Monad.Trans.State
import Control.Monad.Trans.Writer

yoloPrint :: (Show a, Yolo f) => f a -> IO ()
yoloPrint = putStr . ppShow . yolo

class Yolo f where
  yolo :: HasCallStack => f a -> a

instance Yolo Maybe where
  yolo (Just x) = x
  yolo Nothing = error "Yolo!... Nothing"

instance Yolo (Either a) where
  yolo (Right x) = x
  yolo (Left _) = error "Yolo!... Left"

instance Yolo (These a) where
  yolo (That x) = x
  yolo (These _ x) = x
  yolo (This _) = error "Yolo!... This"

instance {-# OVERLAPPING #-} Yolo (Either String) where
  yolo (Right x) = x
  yolo (Left x) = error x

instance Yolo [] where
  yolo = head

instance Yolo IO where
  yolo = unsafePerformIO

instance Yolo Identity where
  yolo (Identity act) = act

instance Yolo m => Yolo (IdentityT m) where
  yolo = yolo . runIdentityT

instance Yolo m => Yolo (MaybeT m) where
  yolo (MaybeT act) = yolo . yolo $ act

instance Yolo m => Yolo (WriterT w m) where
  yolo (WriterT act) = fst . yolo $ act

instance Yolo m => Yolo (ExceptT e m) where
  yolo = yolo . yolo . runExceptT

instance {-# OVERLAPPING #-} Yolo m => Yolo (ExceptT String m) where
  yolo = yolo . yolo . runExceptT

instance (Yolo m, Default r) => Yolo (ReaderT r m) where
  yolo = yolo . flip runReaderT def

instance (Yolo m, Monad m, Default r) => Yolo (StateT r m) where
  yolo = yolo . flip evalStateT def

instance (Yolo m, MonadUnliftIO m) => Yolo (ResourceT m) where
  yolo = yolo . runResourceT
