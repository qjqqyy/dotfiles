module Bar.SkelConfig where

import Colours

import Xmobar
import XMonad.Hooks.DynamicLog hiding (xmobar)

import Data.List

mkConfig :: [String] -> [Runnable] -> Config -> Config
mkConfig extraItems extraCommands baseConfig = baseConfig
    { bgColor = base07
    , fgColor = base01
    , template = "%StdinReader%}%XMonadLog%{ " ++ alternate ("%date%" : extraItems)
    , commands =
        [ Run StdinReader
        , Run XMonadLog
        , Run $ Date ("%a, %e %b %Y " .|. " %H:%M") "date" 250
        ] ++ extraCommands
    }

alternate :: [String] -> String
alternate = intercalate " " . reverse . zipWith ($) (cycle [w, id])
    where w = xmobarColor base01 base06 . pad

-- almost invisible vertical bar
(.|.) :: String -> String -> String
a .|. b = a ++ xmobarColor base05 base06 "|" ++ b
