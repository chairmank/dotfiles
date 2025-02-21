import qualified Solarized as Solarized
import Text.Printf (printf)
import qualified XMonad
import qualified XMonad.Actions.GroupNavigation as GroupNavigation
import qualified XMonad.Config as Config
import qualified XMonad.Core as Core
import qualified XMonad.Hooks.DynamicLog as DynamicLog
import qualified XMonad.Hooks.StatusBar as StatusBar
import qualified XMonad.Hooks.StatusBar.PP as StatusBar.PP
import qualified XMonad.Main as Main
import qualified XMonad.Util.CustomKeys as CustomKeys

fontName = "Monospace"

fontSize = 20 :: Int

-- xmobar looks for its configuration file at $XDG_CONFIG_HOME/xmobar/xmobarrc
xmobar =
  printf
    "xmobar --position='TopH %d' --font='%s %d' --bgcolor='%s' --fgcolor='%s'"
    height
    fontName
    fontSize
    Solarized.base03
    Solarized.base0
  where
    -- kludge to work around a height bug in xmobar
    height = (round $ fromIntegral fontSize * 1.6) :: Int

statusBarPP =
  StatusBar.PP.def
    { StatusBar.PP.ppCurrent = StatusBar.PP.xmobarColor Solarized.base03 Solarized.base0 . StatusBar.PP.pad,
      StatusBar.PP.ppVisible = StatusBar.PP.xmobarColor Solarized.base03 Solarized.base01 . StatusBar.PP.pad,
      StatusBar.PP.ppHidden = StatusBar.PP.xmobarColor Solarized.base0 Solarized.base03 . StatusBar.PP.pad,
      StatusBar.PP.ppHiddenNoWindows = StatusBar.PP.xmobarColor Solarized.base01 Solarized.base03 . StatusBar.PP.pad,
      StatusBar.PP.ppUrgent = StatusBar.PP.xmobarColor Solarized.orange Solarized.base02 . StatusBar.PP.pad,
      StatusBar.PP.ppSep = "",
      StatusBar.PP.ppWsSep = "",
      StatusBar.PP.ppTitle = StatusBar.PP.xmobarColor Solarized.blue "" . StatusBar.PP.shorten 30 . StatusBar.PP.pad,
      StatusBar.PP.ppLayout = StatusBar.PP.xmobarColor Solarized.green "" . StatusBar.PP.pad . (take 1)
    }

dmenu =
  printf
    "dmenu_run -fn '%s-%d' -nb '%s' -nf '%s' -sb '%s' -sf '%s'"
    fontName
    fontSize
    Solarized.base03
    Solarized.base0
    Solarized.base02
    Solarized.orange

keys =
  CustomKeys.customKeys deleteKeys insertKeys
  where
    deleteKeys :: Core.XConfig Core.Layout -> [(XMonad.KeyMask, XMonad.KeySym)]
    deleteKeys _ = []

    insertKeys :: Core.XConfig Core.Layout -> [((XMonad.KeyMask, XMonad.KeySym), Core.X ())]
    insertKeys config@(Core.XConfig {Core.modMask = modMask}) =
      [ ((modMask, XMonad.xK_p), XMonad.spawn dmenu),
        ((modMask, XMonad.xK_Tab), GroupNavigation.nextMatch GroupNavigation.History (return True))
      ]

terminal = "uxterm"

startupHook :: Core.X ()
startupHook = do
  Core.spawn $ printf "xsetroot -solid '%s'" Solarized.base02
  Core.spawn "xrdb -load ~/.Xresources"

config =
  Config.def
    { Core.normalBorderColor = Solarized.base02,
      Core.focusedBorderColor = Solarized.base0,
      Core.terminal = terminal,
      Core.workspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"],
      Core.keys = keys,
      Core.borderWidth = 4,
      Core.logHook = GroupNavigation.historyHook,
      Core.startupHook = startupHook,
      Core.focusFollowsMouse = True,
      Core.clickJustFocuses = False
    }

main = do
  statusBarConfig <- StatusBar.statusBarPipe xmobar (pure statusBarPP)
  Main.xmonad $ StatusBar.withEasySB statusBarConfig StatusBar.defToggleStrutsKey config
