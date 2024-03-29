module BaseXMonad (MachineSpecificCrap(..), mkMain) where

import Colours

import XMonad
import qualified XMonad.StackSet as W

import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.IfLandscape
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect
import XMonad.Layout.Spacing
import XMonad.Util.CustomKeys
import XMonad.Util.Run

import Control.Arrow (second)
import Data.List (isSuffixOf)
import Graphics.X11.ExtraTypes.XF86
import System.Exit

data MachineSpecificCrap = MachineSpecificCrap
    { titleWidth :: Int }

mkMain :: MachineSpecificCrap -> IO ()
mkMain msc = do
    xmobarPipe <- spawnPipe "xmobar -d"
    xmonad $ docks . ewmh . withUrgencyHook NoUrgencyHook $ def
        { modMask = mod4Mask
        , terminal = "urxvtc-256color"
        , keys = customKeys delKeys insKeys
        , normalBorderColor = base06
        , focusedBorderColor = blue
        , workspaces = wsNames
        , layoutHook =
            smartBorders $
            ifLandscape
              ((avoidStruts . gaps . reflectHoriz $ Tall 1 (3/100) (1/2)) ||| Full)
              ((avoidStruts . gaps . reflectVert $ Mirror (Tall 1 (3/100) (1/2))) ||| Full)
        , handleEventHook = handleEventHook def <> fullscreenEventHook
        , manageHook = mconcat
            [ isFullscreen --> doFullFloat
            , manageDocks
            , className =? "Firefox" <&&> appName =? "Places" --> doFloat
            , className =? "Firefox" <&&> appName =? "Navigator" --> doShift (wsNames !! 1)
            , className =? "Chromium-browser" <&&> appName =? "chromium-browser" --> doShift (wsNames !! 2)
            , className =? "Thunderbird" <&&> appName =? "Mail" --> doShift (wsNames !! 5)
            , className =? "dolphin" --> doFloat
            , className =? "discord" <&&> appName =? "discord" <&&> title =? "Discord Updater" --> doIgnore
            , className =? "discord" <&&> appName =? "discord" --> doShift (wsNames !! 0)
            , manageHook def
            ]
        , logHook = do
            dynamicLogWithPP workspacePP { ppOutput = hPutStrLn xmobarPipe }
            dynamicLogString titlePP >>= xmonadPropLog
        }
  where
    gaps = spacingRaw True (Border 0 2 2 2) True (Border 2 2 2 2) True
    workspacePP = def
        { ppCurrent = mkWorkspacePP purple
        , ppVisible = mkWorkspacePP green
        , ppUrgent  = mkWorkspacePP red
        , ppHidden  = mkWorkspacePP base05
        , ppWsSep = ""
        , ppOrder = \(ws:_) -> [ws]
        }
    titlePP = def
        { ppTitle = xmobarColor base00 "" . shorten (titleWidth msc)
        , ppOrder = \(_:_:t:_) -> [t]
        }

wsNames = ["壹", "貳", "參", "肆", "伍", "陸", "柒", "捌", "玖", "拾"]
wsIndexOf "壹" = '1'
wsIndexOf "貳" = '2'
wsIndexOf "參" = '3'
wsIndexOf "肆" = '4'
wsIndexOf "伍" = '5'
wsIndexOf "陸" = '6'
wsIndexOf "柒" = '7'
wsIndexOf "捌" = '8'
wsIndexOf "玖" = '9'
wsIndexOf "拾" = '0'
barWsName bgColor = xmobarColor base01 bgColor . wrap "<fn=1>  " "  </fn>"
barWsAction wsIndex = wrap ("<action=`xdotool key super+" ++ (wsIndex:"`>")) "</action>"
mkWorkspacePP colour = (barWsAction . wsIndexOf) <*> (barWsName colour)

-- keybinds
delKeys :: XConfig l -> [(KeyMask, KeySym)]
delKeys XConfig {modMask = modm} =
    [ (modm .|. shiftMask, xK_Return) -- terminal
    , (modm,               xK_p     ) -- dmenu
    , (modm .|. shiftMask, xK_p     ) -- gmrun
    , (modm .|. shiftMask, xK_c     ) -- close focused window
    , (modm,               xK_h     ) -- shrink master
    , (modm,               xK_l     ) -- expand master
    , (modm              , xK_comma ) -- Increment the number of windows in the master area
    , (modm              , xK_period) -- Deincrement the number of windows in the master area
    , (modm              , xK_space ) -- Rotate through the available layout algorithms
    ] ++
    -- rebind workspaces
    [ (modm .|. m, k) | m <- [shiftMask, 0], k <- [xK_1 .. xK_9] ]

insKeys :: XConfig Layout -> [((KeyMask, KeySym), X ())]
insKeys conf@(XConfig {modMask = modm}) =
    [ ((modm,               xK_Return), spawn $ terminal conf)
    -- back and forth
    , ((modm,               xK_slash ), toggleWS)
    , ((modm .|. shiftMask, xK_slash ), gets (W.currentTag . windowset) >>= toggleOrDoSkip [] moveToAndFollow)
    -- rebind quit
    , ((modm .|. shiftMask, xK_q     ), kill) -- close focused window
    , ((mod1Mask,           xK_F4    ), kill)
    , ((modm .|. shiftMask, xK_x     ), io (exitWith ExitSuccess))
    -- invert binds for shrinking and expanding master
    , ((modm,               xK_h     ), sendMessage Expand)
    , ((modm,               xK_l     ), sendMessage Shrink)
    -- invert binds for increasing and decreasing number of windows in master
    , ((modm              , xK_comma ), sendMessage (IncMasterN (-1)))
    , ((modm              , xK_period), sendMessage (IncMasterN 1))
    , ((mod1Mask          , xK_space ), sendMessage NextLayout)
    -- both modm and alt resets layout on the current workspace
    , ((mod1Mask .|. shiftMask, xK_space), setLayout $ layoutHook conf)
    ] ++
    extraKeys modm ++
    -- move workspace to client then follow along
    [((modm .|. shiftMask, k), toggleOrDoSkip [] moveToAndFollow i) |
        (i, k) <- zip (workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])] ++
    [((modm, k), toggleOrView i) |
        (i, k) <- zip (workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])]
  where
    moveToAndFollow = (.) <$> W.greedyView <*> W.shift

extraKeys :: KeyMask -> [((KeyMask, KeySym), X())]
extraKeys modm = map (second spawn) $
    [ ((controlMask .|. mod1Mask, xK_l), "i3lock_wrapper")
    , ((controlMask,        xK_Print ), "maim --hidecursor --select | xclip -selection clipboard -t image/png")
    , ((mod1Mask,           xK_Print ), "xclip -selection clipboard -o | curl -v -F randomname=a -F file='@-;type=image/png;filename=a.png' 'https://uguu.se/api.php?d=upload-tool' | xclip -f | xclip -selection clipboard")
    , ((modm,               xK_F2    ), "rofi -show run")
    , ((modm .|. shiftMask, xK_Return), "rofi -show ssh")
    , ((modm,               xK_space ), "rofi -show drun")
    , ((mod1Mask,           xK_Tab   ), "rofi -show window")
    , ((0,   xF86XK_MonBrightnessUp  ), "brightnessctl --exponent=2 set +5%")
    , ((0,   xF86XK_MonBrightnessDown), "brightnessctl --exponent=2 set 5%-")
    , ((0,   xF86XK_AudioMute        ), "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    , ((0,   xF86XK_AudioMicMute     ), "pactl set-source-mute @DEFAULT_SOURCE@ toggle")
    , ((0,   xF86XK_AudioLowerVolume ), "pactl set-sink-mute @DEFAULT_SINK@ false; pactl set-sink-volume @DEFAULT_SINK@ -5%")
    , ((0,   xF86XK_AudioRaiseVolume ), "pactl set-sink-mute @DEFAULT_SINK@ false; pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ((0,   xF86XK_AudioPlay        ), "playerctl play-pause")
    , ((0,   xF86XK_AudioNext        ), "playerctl next")
    , ((0,   xF86XK_AudioPrev        ), "playerctl previous")
    ]
