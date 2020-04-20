import Bar.SkelConfig

import Xmobar

config :: Config
config = mkConfig [] [] defaultConfig
    { font = "xft:Fantasque Sans Mono:pixelsize=16"
    , additionalFonts = [ "xft:Noto Sans SC:pixelsize=14" ]
    }

main :: IO ()
main = xmobar config
