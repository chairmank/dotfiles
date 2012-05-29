import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.XPropManage
import XMonad.Actions.CycleWS
import XMonad.Util.CustomKeys
import XMonad.Util.Run
import qualified Data.Map as M

main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

myConfig = defaultConfig
    { terminal = "xterm -sl 10000"
    , layoutHook = myLayoutHook
    , manageHook = myManageHook
    , borderWidth = 1
    , keys = customKeys delKeys insKeys
    }

-- 2 xmobar instances, one teed on the other
myBar = "bash -c \"tee >(xmobar -x0) | xmobar -x1\""
myPP = defaultPP {
       ppCurrent = xmobarColor "#ff0000" "" . wrap "[" "]"
     , ppVisible = xmobarColor "#cccccc" "" . wrap "[" "]"
     , ppHidden = xmobarColor "#cccccc" ""
     , ppLayout = xmobarColor "#cccccc" ""
     , ppTitle = xmobarColor "#ff0000" "" . shorten 100 }

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
dmenu_command = "dmenu_run -fa 'Monospace-15' -nb '#000000' -nf '#cccccc' -sb '#000000' -sf '#ff0000'"
-- delete the old dmenu command
delKeys :: XConfig l -> [(KeyMask, KeySym)]
delKeys conf@(XConfig {modMask = modMask}) =
    [ (modMask, xK_p) ]
-- add my own
insKeys :: XConfig l -> [((KeyMask, KeySym), X ())]
insKeys conf@(XConfig {modMask = modMask}) =
    [ ((modMask, xK_p),   spawn dmenu_command) ]
