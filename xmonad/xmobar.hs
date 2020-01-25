import Data.List
import Xmobar
import XMonad.Hooks.DynamicLog hiding (xmobar)

import Control.Concurrent
import System.Process
import System.IO

config :: Config
config = defaultConfig
    { font = "xft:Fantasque Sans Mono:pixelsize=24"
    , additionalFonts = [ "xft:Noto Sans SC:pixelsize=22"
                        , "xft:FontAwesome:pixelsize=22"
                        ]
    , textOffsets = [ -1, -5 ]
    , bgColor = base07
    , fgColor = base01
    , template = "%StdinReader% }{ " ++ alternate
        [ "%date%"
        , "%battery%"
        , "%wlan0wi%"
        , "%bluetooth%"
        , "%pulsemute% %pulsevolume%"
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
        , Run $ Bluetooth
            (xmobarColor green "" faBluetooth)
            (xmobarColor base04 "" faBluetoothB) 100
        , Run $ PulseVolume 100
        , Run $ PulseMute faVolume faMute 100
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
    faBluetooth = fa "\xf293"
    faBluetoothB = fa "\xf294"
    faVolume = fa "\xf028"
    faMute = fa "\xf026"

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

-- hack haskell threaded wait zombie process weirdness
hackRun :: (String -> IO ()) -> FilePath -> [String] -> IO ThreadId
hackRun cb cmd args = forkIO $ do
    (_, hstdout, _, p) <- runInteractiveProcess cmd args Nothing Nothing
    hSetBinaryMode hstdout False
    hGetLine hstdout
        >>= cb
    waitForProcess p
    pure ()

-- hacky bluetooth indicator
data Bluetooth = Bluetooth String String Int deriving (Read, Show)

instance Exec Bluetooth where
    start (Bluetooth on off r) cb = go
        where
          go = hackRun (cb . replace) "bluetooth" [] >> tenthSeconds r >> go
          replace str
            | "on"  `isInfixOf` str = on
            | "off" `isInfixOf` str = off
            | otherwise             = "install tlp"

    alias _ = "bluetooth"

-- hacky audio indicator
data PulseVolume = PulseVolume Int deriving (Read, Show)

instance Exec PulseVolume where
    alias _ = "pulsevolume"
    start (PulseVolume r) cb = go
        where go = hackRun cb "pamixer" ["--get-volume"] >> tenthSeconds r >> go

data PulseMute = PulseMute String String Int deriving (Read, Show)

instance Exec PulseMute where
    alias _ = "pulsemute"
    start (PulseMute unmuted muted r) cb = go
        where go = hackRun (cb . replace) "pamixer" ["--get-mute"] >> tenthSeconds r >> go
              replace "true" = muted
              replace "false" = unmuted
              replace _ = "install pamixer"
