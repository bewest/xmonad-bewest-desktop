-------------------------

import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome

myManageHook = composeAll (
    [ manageHook gnomeConfig
    , className =? "unity-2d-panel" --> doIgnore
    , className =? "unity-2d-shell" --> doFloat
    ])

main = xmonad gnomeConfig
     {
       terminal = "xterm"
     , manageHook = myManageHook
     }

------
-- EOF
