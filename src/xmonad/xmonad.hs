import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.XPropManage
import XMonad.Actions.CycleWS
import XMonad.Actions.GroupNavigation
import XMonad.Util.CustomKeys
import XMonad.Util.Run
import qualified Data.Map as M
import Solarized
import Text.Printf

main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

myConfig = defaultConfig
    { terminal = "xterm -sl 10000"
    , layoutHook = myLayoutHook
    , manageHook = myManageHook
    , logHook = historyHook
    , borderWidth = 1
    , normalBorderColor = solarizedBase02
    , focusedBorderColor = solarizedCyan
    , keys = customKeys delKeys insKeys
    }

-- 2 xmobar instances, one teed on the other
myBar = "bash -c \"tee >(xmobar -x0) | xmobar -x1\""
myPP = defaultPP {
       ppCurrent = xmobarColor solarizedCyan "" . wrap "[" "]"
     , ppVisible = xmobarColor solarizedBase0 "" . wrap "[" "]"
     , ppHidden = xmobarColor solarizedBase0 ""
     , ppLayout = xmobarColor solarizedBase0 ""
     , ppTitle = xmobarColor solarizedBase0 "" . shorten 100 }
-- TODO: figure out how to set xmobar background color

-- tiling layout
myLayoutHook = Mirror tiled ||| tiled ||| Full
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1/2
    delta = 4/100

-- special window management
myManageHook = composeAll
    [ (className =? "Tk") --> doFloat
    , (className =? "Download") --> doFloat
    , (className =? "Nvidia-settings") --> doFloat
    , (className =? "Gnome-volume-control") --> doFloat
    , (className =? "Gnome-mouse-properties") --> doFloat
    , (className =? "Gnome-panel") --> doFloat
    , (className =? "Toplevel") --> doFloat
    , (className =? "Ncview") --> doFloat
    , (className =? "Vncviewer") --> doFloat
    , (className =? "feh") --> doFloat
    , (className =? "Tilda") --> doFloat
    , (className =? "Skype") --> doFloat
    , (className =? "Software-center") --> doFloat
    , (className =? "Synaptic") --> doFloat
    , (className =? "VCLSalFrame.DocumentWindow") --> doFloat
    , (className =? "OpenOffice.org 3.2") --> doFloat
    , (className =? "empathy") --> doFloat
    , (className =? "Empathy") --> doFloat
    , (className =? "Gimp") --> doFloat
    , (className =? "Soffice") --> doFloat
    , (className =? "soffice") --> doFloat
    ]

-- keybindings
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

dmenu_command = printf "dmenu_run -fa 'Monospace-15' -nb '%s' -nf '%s' -sb '%s' -sf '%s'"
    solarizedBase02 solarizedBase0 solarizedYellow solarizedBase03

-- delete the old dmenu command
delKeys :: XConfig l -> [(KeyMask, KeySym)]
delKeys conf@(XConfig {modMask = modMask}) =
    [ (modMask, xK_p) ]
-- add my own
insKeys :: XConfig l -> [((KeyMask, KeySym), X ())]
insKeys conf@(XConfig {modMask = modMask}) =
    [ ((modMask              , xK_p),      spawn dmenu_command)
    , ((modMask              , xK_Right),  nextWS)
    , ((modMask              , xK_Left),   prevWS)
    , ((modMask .|. shiftMask, xK_Right),  shiftToNext)
    , ((modMask .|. shiftMask, xK_Left),   shiftToPrev)
    , ((modMask              , xK_Tab),    nextMatch History (return True))
    ]
