import Bar.Indicators
import Bar.SkelConfig
import Colours

import Xmobar
import XMonad.Hooks.DynamicLog hiding (xmobar)

extraItems = [ "%battery%"
             , "%wlan0wi%"
             , "%bluetooth%"
             , "%pulsemute% %pulsevolume%"
             ]

extraCommands =
    [ Run $ Battery
        [ "-t" , "<acstatus>"
        , "-l", red
        , "--"
        , "-O", faBolt        ++ " <left>% " ++ xmobarColor base04 "" "| <timeleft>"
        , "-i", faBatteryFull ++ " <left>%"
        , "-o", faBatteryHalf ++ " <left>% " ++ xmobarColor base04 "" "| <timeleft>"
        ] 100
    , Run $ Wireless "wlan0"
        [ "-t", faWifi ++ " <essid>"
        ] 100
    , Run $ Bluetooth
        (xmobarColor green "" faBluetooth)
        (xmobarColor base04 "" faBluetoothB) 100
    , Run $ PulseVolume 100
    , Run $ PulseMute faVolume faMute 100
    ]
  where
    -- fa icons
    fa = wrap "<fn=2>" "</fn>"
    faBatteryFull = fa "\xf240"
    faBolt = fa "\xf0e7"
    faBatteryHalf = fa "\xf242"
    faWifi = fa "\xf1eb"
    faBluetooth = fa "\xf293"
    faBluetoothB = fa "\xf294"
    faVolume = fa "\xf028"
    faMute = fa "\xf026"


config :: Config
config = mkConfig (MachineSpecificCrap extraItems extraCommands) defaultConfig
    { font = "xft:Fantasque Sans Mono:size=9"
    , additionalFonts = [ "xft:Noto Sans SC:size=8"
                        , "xft:FontAwesome:size=8"
                        ]
    }

main :: IO ()
main = xmobar config
