module Bar.Indicators where

import Colours

import Xmobar

import Control.Concurrent
import Data.List
import System.Process
import System.IO

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
