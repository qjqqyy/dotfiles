module Bar.SkelConfig (MachineSpecificCrap(..), mkConfig, mkMain) where

import Colours

import Xmobar
import XMonad.Core (uninstallSignalHandlers)
import XMonad.Hooks.DynamicLog hiding (xmobar)

import Data.List

data MachineSpecificCrap = MachineSpecificCrap
    { templateItems :: [String]
    , extraCommands :: [Runnable]
    }

mkConfig :: MachineSpecificCrap -> Config -> Config
mkConfig mss baseConfig = baseConfig
    { bgColor = base07
    , fgColor = base01
    , template = "%UnsafeStdinReader%}%XMonadLog%{ " ++ alternate ("%date%" : templateItems mss)
    , commands =
        [ Run UnsafeStdinReader
        , Run XMonadLog
        , Run $ Date ("%a, %e %b %Y " .|. " %H:%M") "date" 250
        ] ++ extraCommands mss
    }

mkMain :: MachineSpecificCrap -> Config -> IO ()
mkMain mss baseConfig = uninstallSignalHandlers >> xmobar (mkConfig mss baseConfig)

alternate :: [String] -> String
alternate = intercalate " " . reverse . zipWith ($) (cycle [w, id])
    where w = xmobarColor base01 base06 . pad

-- almost invisible vertical bar
(.|.) :: String -> String -> String
a .|. b = a ++ xmobarColor base05 base06 "|" ++ b
