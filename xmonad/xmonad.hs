import Graphics.X11.ExtraTypes.XF86
import System.Exit
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect
import XMonad.Util.CustomKeys
import XMonad.Util.Run

import qualified XMonad.StackSet as W

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
    , ((modm .|. shiftMask, xK_x     ), io (exitWith ExitSuccess))
    -- invert binds for shrinking and expanding master
    , ((modm,               xK_h     ), sendMessage Expand)
    , ((modm,               xK_l     ), sendMessage Shrink)
    ] ++
    extraKeys ++
    -- move workspace to client then follow along
    [((modm .|. shiftMask, k), windows $ W.greedyView i . W.shift i) |
        (i, k) <- zip (workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])] ++
    [((modm, k), toggleOrView i) |
        (i, k) <- zip (workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])]

extraKeys :: [((KeyMask, KeySym), X())]
extraKeys =
    [ ((mod1Mask,           xK_F2    ), spawn "dmenu_run -fn 'Latin Modern Mono-12'")
    , ((controlMask .|. mod1Mask, xK_l), spawn "i3lock_wrapper")
    , ((0,   xF86XK_MonBrightnessUp  ), spawn "brightnessctl set +10%")
    , ((0,   xF86XK_MonBrightnessDown), spawn "brightnessctl set 10%-")
    ]

myLayout = (avoidStruts . reflectHoriz $ tiled) ||| Full
  where
     tiled   = Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100

main = do
    xmobarPipe <- spawnPipe "xmobar -d"
    xmonad $ docks . withUrgencyHook NoUrgencyHook $ def
        { modMask = mod4Mask
        , terminal = "urxvtc"
        , keys = customKeys delKeys insKeys
        , normalBorderColor = "#2a0834"
        , focusedBorderColor = "#4527f2"
        , workspaces = wsNames
        -- fixups for docks
        , layoutHook = smartBorders myLayout
        , manageHook = mconcat
            [ isFullscreen --> doFullFloat
            , manageDocks
            , className =? "Firefox" --> doShift (wsNames !! 1)
            , manageHook def
            ]
        -- bar
        , logHook = dynamicLogWithPP $ def
            { ppOutput = hPutStrLn xmobarPipe
            , ppTitle = (wrap " <fn=2>\xf2d0</fn> " "") . xmobarColor "#e5cece" "" . shorten 91
            , ppCurrent = barWsName "#9b0877"
            , ppVisible = barWsName "#637e35"
            , ppUrgent  = barWsName "#e122a4"
            , ppHidden  = barWsName "#4c114e"
            , ppSep = " "
            , ppWsSep = ""
            , ppLayout = const ""
            }
        }
  where
    barWsName bgColor = xmobarColor "#ccadcc" bgColor . wrap "<fn=1>  " "  </fn>"
