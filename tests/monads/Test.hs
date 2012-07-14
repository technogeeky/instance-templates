{-# LANGUAGE TemplateHaskell, QuasiQuotes, DeriveDataTypeable, RankNTypes, ConstraintKinds #-}
module Test where

import qualified Classes as D
import Prelude (Eq, Read, Show, (+))
import Templates
import Language.Haskell.InstanceTemplates
import Prelude (zipWith, repeat, ($), const, id)

newtype ZipList a = ZipList [a]
  deriving (Eq, Read, Show)

$(instantiate
 [template Applicative_Template [t| Applicative ZipList |]
   [d|
-- instance Applicative ZipList where
    (ZipList fs) <*> (ZipList xs) = ZipList (zipWith ($) fs xs)
    pure x                        = ZipList (repeat x)

    (*>) :: D.Applicative f => f a -> f b -> f b
    (*>) = D.liftA2 (const id)
    (<*) :: D.Applicative f => f a -> f b -> f a
    (<*) = D.liftA2 const
   |]
 ])

data Maybe a = Just a | Nothing
  deriving (Eq, Read, Show)

$(instantiate
 [template Monad_Template [t| Monad Maybe |] [d|
-- instance Monad  where
    Just x >>= k  =  k x
    Nothing >>= _ =  Nothing

    Just _ >> k   =  k
    Nothing >> _  =  Nothing

    return x      =  Just x

    fail _        =  Nothing
 |] ])

testFunctor = D.map (+1) $ Just 4