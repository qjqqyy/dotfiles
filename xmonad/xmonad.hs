import XMonad
import XMonad.StackSet (greedyView, shift)

import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect
import XMonad.Util.CustomKeys
import XMonad.Util.Run

import Control.Arrow (second)
import Graphics.X11.ExtraTypes.XF86
import System.Exit


extraKeys :: KeyMask -> [((KeyMask, KeySym), X())]
extraKeys modm = map (second spawn) $
    [ ((controlMask .|. mod1Mask, xK_l), "i3lock_wrapper")
    , ((controlMask,        xK_Print ), "maim -s | xclip -selection clipboard -t image/png")
    , ((mod1Mask,           xK_F2    ), "rofi -show run")
    , ((modm .|. shiftMask, xK_Return), "rofi -show ssh")
    , ((mod1Mask,           xK_space ), "rofi -show drun")
    , ((mod1Mask,           xK_Tab   ), "rofi -show window")
    , ((0,   xF86XK_MonBrightnessUp  ), "brightnessctl set +10%")
    , ((0,   xF86XK_MonBrightnessDown), "brightnessctl set 10%-")
    , ((0,   xF86XK_AudioMute        ), "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    , ((0,   xF86XK_AudioMicMute     ), "pactl set-source-mute @DEFAULT_SOURCE@ toggle")
    , ((0,   xF86XK_AudioLowerVolume ), "pactl set-sink-mute @DEFAULT_SINK@ false; pactl set-sink-volume @DEFAULT_SINK@ -5%")
    , ((0,   xF86XK_AudioRaiseVolume ), "pactl set-sink-mute @DEFAULT_SINK@ false; pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ((0,   xF86XK_AudioPlay        ), "playerctl play-pause")
    , ((0,   xF86XK_AudioNext        ), "playerctl next")
    , ((0,   xF86XK_AudioPrev        ), "playerctl previous")
    ]


main = do
    xmobarPipe <- spawnPipe "xmobar -d"
    xmonad $ docks . ewmh . withUrgencyHook NoUrgencyHook $ def
        { modMask = mod4Mask
        , terminal = "urxvtc"
        , keys = customKeys delKeys insKeys
        , normalBorderColor = "#2a0834"
        , focusedBorderColor = "#4527f2"
        , workspaces = wsNames
        , layoutHook = smartBorders $
            (avoidStruts . reflectHoriz $ Tall 1 (3/100) (1/2)) ||| Full
        , handleEventHook = handleEventHook def <> fullscreenEventHook
        , manageHook = mconcat
            [ isFullscreen --> doFullFloat
            , manageDocks
            , className =? "Firefox" <&&> appName =? "Places" --> doFloat
            , className =? "Firefox" --> doShift (wsNames !! 1)
            , manageHook def
            ]
        , logHook = do
            dynamicLogWithPP workspacePP { ppOutput = hPutStrLn xmobarPipe }
            dynamicLogString titlePP >>= xmonadPropLog
        }
  where
    barWsName bgColor = xmobarColor "#ccadcc" bgColor . wrap "<fn=1>  " "  </fn>"
    workspacePP = def
        { ppCurrent = barWsName "#9b0877"
        , ppVisible = barWsName "#637e35"
        , ppUrgent  = barWsName "#e122a4"
        , ppHidden  = barWsName "#4c114e"
        , ppWsSep = ""
        , ppOrder = \(ws:_) -> [ws]
        }
    titlePP = def
        { ppTitle = xmobarColor "#e5cece" "" . shorten 75
        , ppOrder = \(_:_:t:_) -> [t]
        }

wsNames = ["壹", "貳", "參", "肆", "伍", "陸", "柒", "捌", "玖", "拾"]

-- keybinds
delKeys :: XConfig l -> [(KeyMask, KeySym)]
delKeys XConfig {modMask = modm} =
    [ (modm .|. shiftMask, xK_Return) -- terminal
    , (modm,               xK_p     ) -- dmenu
    , (modm .|. shiftMask, xK_p     ) -- gmrun
    , (modm .|. shiftMask, xK_c     ) -- close focused window
    , (modm,               xK_h     ) -- shrink master
    , (modm,               xK_l     ) -- expand master
    ] ++
    -- rebind workspaces
    [ (modm .|. m, k) | m <- [shiftMask, 0], k <- [xK_1 .. xK_9] ]

insKeys :: XConfig l -> [((KeyMask, KeySym), X ())]
insKeys conf@(XConfig {modMask = modm}) =
    [ ((modm,               xK_Return), spawn $ terminal conf)
    -- back and forth
    , ((modm,               xK_slash ), toggleWS)
    -- rebind quit
    , ((modm .|. shiftMask, xK_q     ), kill) -- close focused window
    , ((mod1Mask,           xK_F4    ), kill)
    , ((modm .|. shiftMask, xK_x     ), io (exitWith ExitSuccess))
    -- invert binds for shrinking and expanding master
    , ((modm,               xK_h     ), sendMessage Expand)
    , ((modm,               xK_l     ), sendMessage Shrink)
    ] ++
    extraKeys modm ++
    -- move workspace to client then follow along
    [((modm .|. shiftMask, k), windows $ greedyView i . shift i) |
        (i, k) <- zip (workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])] ++
    [((modm, k), toggleOrView i) |
        (i, k) <- zip (workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])]
