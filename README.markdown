
This repo will configure xmonad on ubuntu.

I use it to sync xmonad configs on any ubuntu computer I'm using as a desktop.
If you've got xmonad and ubuntu installed and up to date, this will get you up
and running with xmonad in about five minutes.

  * Author: Ben West
  * Website: http://github.com/bewest/xmonad-bewest-desktop

## QUICK GUIDE

```bash
    $ make install
    # Log out, select the xmonad session with your user name from GDM. DONE.
```

This has no impact on your system or your ability to upgrade packages.
We installed a new xsession pointed at your stuff, symlinked into your
home directory.  `alt-b` was added to toggle the panel at the top.
Logging in should produce a nice ready-to-use xmonad session for you.

If something goes horribly wrong and fails (it wont'), you can log out
using alt-Q, or at worst killall xmonad.start, and your old sessions
are ready to go.  Your old gnome-session is specified as the fallback
behavior in case your xmonad.start goes horribly awry.  If you find
yourself inf stock gnome, check `~/.xesssion-errors`.

Doing:
```bash
git clone git://github.com/bewest/xmonad-bewest-desktop.git
cd xmonad-bewest-desktop
make install
```
Should inform of how it installs a custom xsession pointed at your
~/bin/xmonad.start which is used to start X.  You can now log out, and
select the xmonad session pointing at your xmonad.start.  I've
provided a simple one that starts gnome-session and dbus so that eg
Firefox menus look correct, and docks work correctly.

I also copy a basic xmonad config that tries not to do anything fancy.
I used to use the default xmonad config.  The config that is in place
is to restore default xmonad configurations from broken 3rd party
overrides.


### Make targets:

    show-nautilus-desktop
      Issue a command that tells Nautilus to turn it's desktop feature back on.
    hide-nautilus-desktop
      Issue a command that tells Nautilus to turn it's desktop feature OFF.
    install
      Generate and Install our desktop file, disable the Nautilus desktop.
      Install our xmonad.hs in the right place.
    desktop
      Show the results of generating a desktop file.


Ubuntu ships with a reasonable gnome setup.  This includes using Nautilus in a
Windows/Mac style bid to control many facets of the UI.  Nautilus opens up a
window that will hover over all other windows.  You can move it around by
holding meta ( ALT ), holding mouse three and dragging the window.  The make
file includes handy targets to control this feature of Nautilus.

Ubuntu's startup is a complicated process.  The method we use is to install a
desktop description file describing an xsession in the canonical
location [ /usr/share/xsessions ].  This makes it available to you as
a selection when GDM asks you to log in.  The desktop description
tells GDM to use a script of our making.  It serves the same purpose
as all those xsession / xinit and myriad variations.


## Theory of operation

This is a brief snynopsis of how systems like Ubuntu get gnome,
sessions, window managers, and other expected comforts up and running.
Use this description at your own risk.

Xorg starts up and through xsessions has some support for xsessions.
Ubuntu replaces the default xdm greeter with gdm, which reads
available xsessions from `/usr/share/xsessions/` which are stored as
`.desktop` files.  The exec name is used to stat a dbus sessions
coordinated with gnome.  All future "session-ish" names must match
this name in order for all of gnome's features to work.  Without this
matching things will mostly work, but Firefox menus will be ugly, for example.

The common case is to execute gnome-session, which loads sessions
described in `/usr/share/gnome-sessions/sessions/*.session`.
These files describe a chain of dependencies, which are resolved by
looking up definitions in `/usr/share/applications/*.desktop`.
However, some "components" aren't defined here?

Here's an example:
My xsession specified Exec=gnome-session --session xmonad.start
This produces:

* `dbus-launch --exit-with-session gnome-session --sesssion xmonad.start`
* gnome-session --session xmonad.start

    bewest@paragon:~$ ps aux | grep session
    [...]
    bewest    7453  0.1  0.3 390600  9864 ?        Ssl  20:43   0:00 gnome-session --session xmonad.start
    bewest    7555  0.0  0.0  26548   796 ?        S    20:43   0:00 /usr/bin/dbus-launch --exit-with-session gnome-session --session xmonad.start

So in order for everything to work correctly, the Exec line of the
xsession definition must match the --session argument crafted for gnome-session.

The whole process of dependency finding can be short-circuited by
specifying your custom `xmonad.start` as an xsession definition,
starting gnome-session and launching dbus-launch yourself.  This at
least fixes things like Firefox menus, and probably lots of other
stuff.  You will also need to start panels and whatnot in your script.

The more complicated version goes like this:
xsession uses a custom wrapper, called `gnome-session-xmonad` which
gets --exit-with-session gnome-session-xmonad because of
`Eval=gnome-session-xmonad`.  This needs to create a gnome-session
called gnome-session-xmonad which can be looked up in
`/usr/share/gnome-session/sessions/gnome-session-xmonad.session.`
From here it's probably safe to start xmonad through the provided
`/usr/share/applications/xmonad.desktop` however, clever use of
`TryExec` here can allow us to execute xmonad.start, and then try
xmonad if it fails.

Complicated version doesn't seem to work:

    bewest@paragon:~$ ps aux | grep xmonad| grep -v vim
    bewest    7579  0.0  0.0  12328   708 ?        S    05:51   0:00 /bin/bash /home/bewest/bin/xmonad.start
    bewest    9166  0.0  0.3 390600  9828 ?        Ssl  10:14   0:00 gnome-session --session gnome-session-xmonad
    bewest    9268  0.0  0.0  26548   796 ?        S    10:14   0:00 /usr/bin/dbus-launch --exit-with-session gnome-session-xmonad
    bewest    9283  0.0  0.0  12312  1428 ?        S    10:14   0:00 /bin/bash /home/bewest/bin/xmonad.start
    bewest    9291  0.0  0.0  12312   592 ?        S    10:14   0:00 /bin/bash /home/bewest/bin/xmonad.start
    bewest    9293  0.5  0.1  45048  4328 ?        S    10:14   0:00 /home/bewest/.xmonad/xmonad-x86_64-linux
    bewest    9683  0.0  0.0   9396   924 pts/8    S+   10:16   0:00 grep xmonad
    bewest@paragon:~$ 
This is the expected output, but Firefox menus are still busted.
I can't figure out how to get the session stuff working so Firefox menus match the system.
The easiest way to getting everything to work right seems to be
placing a call to gnome-session and any panels before dbus-launch in
your `xmonad.start` script, and to specify using it in your xsession.
This also reduces the number of configs needed down to one.


## Things Worth Knowing

### Keys

XMonad.Config.Gnome keys are broken on Ubuntu 12.04.

* gnome-session-save is replaced by gnome-session-quit
* alt-p does nothing
* gmrun doesn't exist.

Default bindings:
http://xmonad.org/xmonad-docs/xmonad/src/XMonad-Config.html

```haskell
import System.Exit
myKeys = [

  -- launching and killing programs
  , ((modMask,               xK_p     ), spawn "dmenu_run") -- %! Launch dmenu
  , ((modMask .|. shiftMask, xK_p     ), spawn "gmrun") -- %! Launch gmrun

  -- [...]
  -- quit, or restart
  -- %! Quit xmonad
  , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
]
```

My xmonad.hs fixes these issues, and successfully floats a mac-like
command bar through every workspace correctly.  A new key, `alt-b`
toggles the gap produces.  Very very nice.

### Inacurate/lies
The run script here starts gnome-session and xmonad.  We've taken care of
Nautilus because that window thingy is completely crippling.  But gnome does
do a couple of other things you should know how to handle.

When you first log in, you will be in workspace 1.  Workspace 1 will fill up with
all the desktop panels that gnome's window manager would ordinarily stick up
near the edges of the screen.  Here's the method I use to correct the
situation:

1. Move the window using ALT-MOUSE3 and dragging the window.  This tells
xmonad that this is a floating window, not a tiled window.
2. Right click / MOUSE2 to open the Properties dialog from the context menu
that flies out.
3. Select Expand
4. Select Expand

This procedure basically jostles the window out of xmonad's tiling scheme, and
triggers a redrawing of those windows.  When the redrawing happens, they
usually figure out where they belong.  Occasionally I need to drag it near the
edge after they flatten out and trigger their redrawing again.  This only
happens the first time.  There's probably a nifty xmonad config somewhere that
correctly deals with menus and gutters, but it's never bothered me enough to
spend any time fixing it.

I like having Ubuntu/Debian's system menus available.  xmonad will work with
dmenu and dzen to give you a floating clock and autocompletion.  However, I
typically find that I need a controlling terminal for many of my special
applications.

In college I messed around with Gentoo, linux from scratch, and
several other distros.  Nowadays, I run Ubuntu on a VM inside my Mac
Book pro.  I hate maintaining computers, and Apple's products, while
terrible, seem to require slightly less maintenance from me than other
systems.  However, I hate Apple's GUIs, unless I want to watch a
video, and I didn't want to spend a lot of time with a complicated
FVWM config.  xmonad allowed me to stop worrying about windows and
helps me focus on the task at hand.  I've used xmonad since at least
2009, and I use the default config (except I make the default terminal
xterm).  xmonad wears very well, and is kind of addictive.  Now, when
I approach other computers I find myself confounded by the array of
meaningless UI choices.

#### Configuring XMonad
I try to use the defaults.
See my [bewest/homeware] repo for xterm-blue, and xterm-light, and
some other utilities to bind xterm to different solarized
colorschemes.
Here is the entire file:
-------------------------

```haskell
import XMonad

main = xmonad defaultConfig
     {
       terminal = "xterm"
     }

------
-- EOF
```


## Resources
* http://markhansen.co.nz/xmonad-ubuntu-oneiric/
* http://www.haskell.org/haskellwiki/Xmonad/Using_xmonad_in_Unity_2D
* http://www.haskell.org/haskellwiki/Xmonad/Using_xmonad_in_Gnome
* http://www.elonflegenheimer.com/2012/06/22/xmonad-in-ubuntu-12.04-with-unity-2d.html
* http://askubuntu.com/questions/67653/tiling-window-management-with-unity
* https://github.com/hamaxx/unity-2d-for-xmonad
* https://gist.github.com/1300108
* http://www.kmels.net/posts/how-to/install-xmonad-ubuntu-12.04.html
* http://joedicastro.com/productividad-en-el-escritorio-linux-xmonad.html
* https://gist.github.com/2551959
* http://askubuntu.com/questions/137685/how-can-i-get-xmonad-to-work-with-gnome-3
* http://andredieb.com/posts/14766080456/
* http://www.vicfryzel.com/2011/12/26/true-fullscreen-xmonad
* https://github.com/robertmassaioli/config-files/tree/master/xmonad
* http://www.subsymbol.org/2012/09/xmonad-on-unity-1204.html
* https://gist.github.com/3156991

### Specs

There are specs for these things:
* http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
* https://live.gnome.org/SessionManagement/GnomeSession
* http://standards.freedesktop.org/autostart-spec/autostart-spec-latest.html
* http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
* http://www.freedesktop.org/wiki/Specifications/startup-notification-spec?action=show&redirect=Standards%2Fstartup-notification-spec
* http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html#extra-actions
* 

### Xmonad docs
* http://xmonad.org/xmonad-docs/xmonad/XMonad-ManageHook.html
* http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-ManageDocks.html
* http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Actions-CopyWindow.html

### Misc
* https://github.com/sabetts/stumpwm/wiki/Ubuntu-12.04-and-Gnome-and-StumpWM
* 

## Workspace  

How I use xmonad.

  1. System Administrivia/Control.  I usually keep an xterm scaled
     down to small or tiny tailing some logs, another xterm for launching
     stuff, and synaptic in the main area.  I also browse the Ubuntu
     system menus from here.  I rarely spend time here.  The menus are
     here when I need them and useful for admin stuff.

  2. Browsers.  I use either work or personal profiles here.  xterms
     come and go.

  3. Hacking: browsers and xterms.  Here is usually where I use the
     layout switching ( alt-space ).  I like to manage 2 firefox windows.
     Sometimes they go side by side ( default ), but other times, I want
     full screen firefox.  I alt-space a few times to get full screen
     layout and then shift the rotation to get the one I want.
     Here I use development profiles.

  4. Editing. 2 or 3 xterms OR debug firefox profile and 1 or 2 xterms.
  5. Overflow for editing.
  6. Overflow for editing.
  7. Pidgin.  For some reason, 7 is easy to find whenever I want to chat.
  8. Overflow for editing or... I run the daemon for emacs_xterm in a
     terminal here.
  9. Sometimes an alternate browser profile goes here.
     don't keep track of what happens out here.
  0. Applications I just leave lying around.
     don't keep track of what happens out here.

Most of my time is spent in 3-5.  I no longer have to drag window titlebars or
tiny corners in order to begin working.  I like to use the keybindings as my
background image, because it reinforces the concept whenever there are no
windows in the way.

EOF
