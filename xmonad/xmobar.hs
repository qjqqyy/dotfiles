import Data.List
import Xmobar
import XMonad.Hooks.DynamicLog hiding (xmobar)

config :: Config
config = defaultConfig
    { font = "xft:Fantasque Sans Mono:pixelsize=24"
    , additionalFonts = [ "xft:Noto Sans SC:pixelsize=22"
                        , "xft:FontAwesome:pixelsize=22"
                        ]
    , textOffsets = [ -1, -5 ]
    , bgColor = base07
    , fgColor = base01
    , template = "%StdinReader% } { " ++ alternate
        [ "%date%"
        , "%battery%"
        , "%wlan0wi%"
        , "%disku%"
        ]
    , commands =
        [ Run StdinReader
        , Run $ Date ("%a, %d %b %Y " .|. " %H:%M") "date" 150
        , Run $ Battery
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
        , Run $ DiskU [("/",  faDisk ++ " <free>")] [] 600
        ]
    }
  where
    -- fa icons
    fa = wrap "<fn=2>" "</fn>"
    faBatteryFull = fa "\xf240"
    faBolt = fa "\xf0e7"
    faBatteryHalf = fa "\xf242"
    faWifi = fa "\xf1eb"
    faDisk = fa "\xf0a0"

main :: IO ()
main = xmobar config

-- colours
base00 = "#e5cece"
base01 = "#ccadcc"
base02 = "#b273b9"
base03 = "#a54da5"
base04 = "#703170"
base05 = "#4c114e"
base06 = "#2a0834"
base07 = "#100013"
red = "#e122a4"
purple = "#9b0877"
yellow = "#9b6800"
green = "#637e35"
cyan = "#147e7f"
blue = "#4527f2"
violet = "#7901cb"
magenta = "#b101a9"

alternate :: [String] -> String
alternate = intercalate " " . reverse . zipWith ($) (cycle [w, id])
    where w = xmobarColor base01 base06 . pad

-- almost invisible vertical bar
(.|.) :: String -> String -> String
a .|. b = a ++ xmobarColor base05 base06 "|" ++ b
