
This repo will configure xmonad on ubuntu.

  * Author: Ben West
  * Website: http://github.com/bewest/xmonad-bewest-desktop

## Status

Circa `Tue Sep 18 19:36:31 PDT 2012`, I'm updating to Ubuntu Precise
12, which includes numerous UI updates.

Reading through the resources to figure out the best thing to do.

## QUICK GUIDE


    $ make install
    $ mkdir -p ~/bin ; cp xmonad.start ~/bin/xmonad.start
    Log out, select the xmonad session with your user name from GDM. DONE.

I use it to sync xmonad configs on any ubuntu computer I'm using as a desktop.
If you've got xmonad and ubuntu installed and up to date, this will get you up
and running with xmonad in about five minutes.

Ubuntu ships with a reasonable gnome setup.  This includes using Nautilus in a
Windows/Mac style bid to control many facets of the UI.  Nautilus opens up a
window that will hover over all other windows.  You can move it around by
holding meta ( ALT ), holding mouse three and dragging the window.  The make
file includes handy targets to control this feature of Nautilus.

Ubuntu's startup is a complicated process.  The method we use is to install a
desktop description file in the canonical location [ /usr/share/xsessions ].
This makes it available to you as a selection when GDM asks you to log in.
The desktop description tells GDM to use a script of our making.  It serves
the same purpose as all those xsession / xinit and myriad variations.

Configuring XMonad
I use the defaults.
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

Make targets:
  show-nautilus-desktop
    Issue a command that tells Nautilus to turn it's desktop feature back on.
  hide-nautilus-desktop
    Issue a command that tells Nautilus to turn it's desktop feature OFF.
  install
    Generate and Install our desktop file, disable the Nautilus desktop. 
    Install our xmonad.hs in the right place.
  desktop
    Show the results of generating a desktop file.


## Things Worth Knowing
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

## Resources
* http://markhansen.co.nz/xmonad-ubuntu-oneiric/
* http://www.haskell.org/haskellwiki/Xmonad/Using_xmonad_in_Unity_2D
* http://www.elonflegenheimer.com/2012/06/22/xmonad-in-ubuntu-12.04-with-unity-2d.html
* http://askubuntu.com/questions/67653/tiling-window-management-with-unity
* https://github.com/hamaxx/unity-2d-for-xmonad
* https://gist.github.com/1300108
* http://www.kmels.net/posts/how-to/install-xmonad-ubuntu-12.04.html
* http://joedicastro.com/productividad-en-el-escritorio-linux-xmonad.html

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
