-------------------------

import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.ManageHook
import System.Exit
import XMonad.Util.EZConfig
import qualified Data.Map as M

myKeys conf@(XConfig {modMask = modm}) = M.fromList
  [

  -- launching and killing programs
    ((modm,               xK_p     ), spawn "dmenu_run") -- %! Launch dmenu
  , ((modm.|. shiftMask, xK_p     ), spawn "gmrun") -- %! Launch gmrun

  -- [...]
  -- quit, or restart
  -- %! Quit xmonad
  , ((modm.|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
  ]

myManageHook = composeAll (
    [ manageHook gnomeConfig
    , className =? "Unity-2d-panel" --> doIgnore
    , className =? "Unity-2d-shell" --> doFloat
    ])

main = xmonad $ gnomeConfig
     {
       terminal = "xterm"
     , manageHook = myManageHook
     , keys = myKeys <+> keys gnomeConfig
     }

------
-- EOF
