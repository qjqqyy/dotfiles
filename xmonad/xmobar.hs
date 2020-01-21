import Xmobar

config :: Config
config = defaultConfig
    { font = "xft:Latin Modern Sans:pixelsize=26"
    , additionalFonts = [ "xft:Droid Sans Fallback:pixelsize=24" ]
    , bgColor = "#100013"
    , fgColor = "#ccadcc"
    , template = "%StdinReader% } { <fc=#ccadcc,#2a0834> %wlan0wi% </fc> %battery% <fc=#ccadcc,#2a0834> %date% </fc>"
    , commands =
        [ Run StdinReader
        , Run $ Date "%a, %d %b %Y <fc=#4c114e,#2a0834>|</fc> %H:%M" "date" 150
        , Run $ Battery [ "-t"
                      , "<acstatus> <left>% <fc=#703170>|</fc> <timeleft>"
                      ] 100
        , Run $ Wireless "wlan0"
                [ "-t", "<essid> <fc=#4c114e,#2a0834>|</fc> <quality>" ] 100
        ]
    }

main :: IO ()
main = xmobar config
