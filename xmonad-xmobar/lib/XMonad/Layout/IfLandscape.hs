{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}

-----------------------------------------------------------------------------
-- |
-- Module      :  XMonad.Layout.IfLandscape
-- Copyright   :  (c) Edward Z. Yang
-- License     :  BSD-style (see LICENSE)
--
-- Maintainer  :  <ezyang@cs.stanford.edu>
-- Stability   :  unstable
-- Portability :  unportable
--
-- Configure layouts based on the width of your screen; use your
-- favorite multi-column layout for wide screens and a full-screen
-- layout for small ones.
-----------------------------------------------------------------------------

module XMonad.Layout.IfLandscape
    ( -- * Usage
      -- $usage
      PerScreen,
      ifLandscape
    ) where

import XMonad
import qualified XMonad.StackSet as W

import Data.Maybe (fromMaybe)

-- $usage
-- You can use this module by importing it into your ~\/.xmonad\/xmonad.hs file:
--
-- > import XMonad.Layout.IfLandscape
--
-- and modifying your layoutHook as follows (for example):
--
-- > layoutHook = ifLandscape (Tall 1 (3/100) (1/2) ||| Full) Full
--
-- Replace any of the layouts with any arbitrarily complicated layout.
-- ifLandscape can also be used inside other layout combinators.

ifLandscape :: (LayoutClass l1 a, LayoutClass l2 a)
               => (l1 a)      -- ^ layout to use when the screen is wider (landscape)
               -> (l2 a)      -- ^ layout to use otherwise
               -> PerScreen l1 l2 a
ifLandscape = PerScreen False

data PerScreen l1 l2 a = PerScreen Bool (l1 a) (l2 a) deriving (Read, Show)

-- | Construct new PerScreen values with possibly modified layouts.
mkNewPerScreenT :: PerScreen l1 l2 a -> Maybe (l1 a) ->
                      PerScreen l1 l2 a
mkNewPerScreenT (PerScreen _ lt lf) mlt' =
    (\lt' -> PerScreen True lt' lf) $ fromMaybe lt mlt'

mkNewPerScreenF :: PerScreen l1 l2 a -> Maybe (l2 a) ->
                      PerScreen l1 l2 a
mkNewPerScreenF (PerScreen _ lt lf) mlf' =
    (\lf' -> PerScreen False lt lf') $ fromMaybe lf mlf'

instance (LayoutClass l1 a, LayoutClass l2 a, Show a) => LayoutClass (PerScreen l1 l2) a where
    runLayout (W.Workspace i p@(PerScreen _ lt lf) ms) r
        | rect_width r > rect_height r  = do (wrs, mlt') <- runLayout (W.Workspace i lt ms) r
                                             return (wrs, Just $ mkNewPerScreenT p mlt')
        | otherwise                     = do (wrs, mlt') <- runLayout (W.Workspace i lf ms) r
                                             return (wrs, Just $ mkNewPerScreenF p mlt')

    handleMessage (PerScreen bool lt lf) m
        | bool      = handleMessage lt m >>= maybe (return Nothing) (\nt -> return . Just $ PerScreen bool nt lf)
        | otherwise = handleMessage lf m >>= maybe (return Nothing) (\nf -> return . Just $ PerScreen bool lt nf)

    description (PerScreen True  l1 _) = description l1
    description (PerScreen _     _ l2) = description l2
