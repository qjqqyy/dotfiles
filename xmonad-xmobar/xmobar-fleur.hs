import Bar.SkelConfig

import Xmobar

main :: IO ()
main = mkMain (MachineSpecificCrap [] []) defaultConfig
    { font = "xft:Fantasque Sans Mono:pixelsize=24"
    , additionalFonts = [ "xft:Noto Sans SC:pixelsize=20" ]
    }
