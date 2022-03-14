import qualified Data.Map as Map
import qualified Data.Monoid as Monoid
import qualified Solarized
import qualified Text.Printf as Printf
import qualified XMonad
import qualified XMonad.Actions.CycleWS as CycleWS
import qualified XMonad.Actions.GroupNavigation as GroupNavigation
import qualified XMonad.Config as Config
import qualified XMonad.Core as Core
import qualified XMonad.Hooks.DynamicBars as Bars
import qualified XMonad.Hooks.DynamicLog as Log
import qualified XMonad.Hooks.ManageDocks as Docks
import qualified XMonad.Layout as Layout
import qualified XMonad.Main as Main
import qualified XMonad.Operations as Operations
import qualified XMonad.Util.CustomKeys as CustomKeys
import qualified XMonad.Util.Run as Run

logHook :: Core.X ()
logHook = (Bars.multiPP pp pp)
  where
    pp :: Log.PP
    pp =
      Log.xmobarPP
        { Log.ppCurrent = Log.xmobarColor Solarized.solarizedBase03 Solarized.solarizedBase0 . Log.pad,
          Log.ppVisible = Log.xmobarColor Solarized.solarizedBase03 Solarized.solarizedBase01 . Log.pad,
          Log.ppHidden = Log.xmobarColor Solarized.solarizedBase0 Solarized.solarizedBase03 . Log.pad,
          Log.ppHiddenNoWindows = Log.xmobarColor Solarized.solarizedBase01 Solarized.solarizedBase03 . Log.pad,
          -- TODO how does urgency hook work?
          Log.ppUrgent = Log.xmobarColor Solarized.solarizedOrange "",
          Log.ppWsSep = "",
          Log.ppSep = "",
          Log.ppLayout = ppLayout,
          Log.ppTitle = Log.xmobarColor Solarized.solarizedBlue Solarized.solarizedBase03 . Log.shorten 30 . Log.pad
        }

    ppLayout :: String -> String
    ppLayout layout = Log.xmobarColor Solarized.solarizedGreen Solarized.solarizedBase03 (Log.pad (take 1 layout))

dynamicStatusBar :: Bars.DynamicStatusBar
dynamicStatusBar (Core.S screenId) = Run.spawnPipe $ Printf.printf "xmobar --screen=%s" (show screenId)

dynamicStatusBarCleanup :: Bars.DynamicStatusBarCleanup
dynamicStatusBarCleanup = return ()

startupHook :: Core.X ()
startupHook = Bars.dynStatusBarStartup dynamicStatusBar dynamicStatusBarCleanup

handleEventHook :: XMonad.Event -> Core.X Monoid.All
handleEventHook = Bars.dynStatusBarEventHook dynamicStatusBar dynamicStatusBarCleanup

keys :: Core.XConfig Core.Layout -> Map.Map (XMonad.ButtonMask, XMonad.KeySym) (Core.X ())
keys = CustomKeys.customKeys deleteKeys insertKeys
  where
    deleteKeys :: Core.XConfig Core.Layout -> [(XMonad.KeyMask, XMonad.KeySym)]
    deleteKeys _ = []

    insertKeys :: Core.XConfig Core.Layout -> [((XMonad.KeyMask, XMonad.KeySym), Core.X ())]
    insertKeys config@(Core.XConfig {Core.modMask = modMask}) =
      [ ((modMask, XMonad.xK_b), Operations.sendMessage Docks.ToggleStruts),
        ((modMask, XMonad.xK_p), XMonad.spawn dmenuCommand),
        ((modMask, XMonad.xK_Tab), GroupNavigation.nextMatch GroupNavigation.History (return True)),
        ((modMask, XMonad.xK_u), CycleWS.prevWS),
        ((modMask XMonad..|. XMonad.shiftMask, XMonad.xK_u), CycleWS.shiftToPrev),
        ((modMask, XMonad.xK_i), CycleWS.nextWS),
        ((modMask XMonad..|. XMonad.shiftMask, XMonad.xK_i), CycleWS.shiftToNext)
      ]

    xtermCommand :: String
    xtermCommand = Core.terminal config

    dmenuCommand :: String
    dmenuCommand =
      Printf.printf
        "dmenu_run -fn '%s' -nb '%s' -nf '%s' -sb '%s' -sf '%s'"
        "Source Code Variable-20"
        Solarized.solarizedBase03
        Solarized.solarizedBase0
        Solarized.solarizedBase02
        Solarized.solarizedOrange

-- TODO what is this type signature?
config =
  Docks.docks $
    Config.defaultConfig
      { Core.workspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"],
        Core.borderWidth = 2,
        Core.normalBorderColor = Solarized.solarizedBase02,
        Core.focusedBorderColor = Solarized.solarizedBase0,
        Core.terminal = "xterm",
        -- TODO wtf is XMonad.<+>
        Core.manageHook = Docks.manageDocks XMonad.<+> Core.manageHook Config.defaultConfig,
        Core.layoutHook = Docks.avoidStruts $ Core.layoutHook Config.defaultConfig,
        Core.logHook = logHook XMonad.<+> GroupNavigation.historyHook,
        Core.startupHook = startupHook,
        Core.handleEventHook = handleEventHook,
        Core.keys = keys,
        Core.focusFollowsMouse = True,
        Core.clickJustFocuses = False
      }

main = do
  Main.xmonad $ config
