########################################################
#
# Author: Ben West <bewest@gmail.com>
# Used to manage my xmonad config.
#
#

XSESSION_DIR=/usr/share/xsessions
SESSION=$(USER)-xmonad.desktop
desktop=./xmonad-generate-desktop
check=xmonad --recompile

hide-nautilus-desktop:
	# In order to provide draggable and clickable icons, nautilus organizes all
	# of them on an invisible window.  Get rid of it!
	gconftool --type boolean --set /apps/nautilus/preferences/show_desktop false || echo ''
	gsettings set org.gnome.desktop.background show-desktop-icons false || echo ''

show-nautilus-desktop:
	# Restore it if you decide to go back to gnome.
	gconftool --type boolean --set /apps/nautilus/preferences/show_desktop true || echo ''
	gsettings set org.gnome.desktop.background show-desktop-icons true || echo ''

install: $(XSESSION_DIR)/$(SESSION) \
         $(HOME)/.xmonad/xmonad.hs  \
         check-xmonad               \
         $(HOME)/bin/xmonad.start # \ #hide-nautilus-desktop
	# If your xmonad.hs is ready, cp xmonad.start ~/bin/
	# It should be available as $(SESSION) in the sessions list when you select
	# your user name in GDM.

desktop: $(realpath $(SESSION))
	# Preview what generating a desktop file for you will look like.
	$(desktop)

check-xmonad:
	# Checking to see xmonad can read your config.
	$(check)
	# If $(check) printed nothing, your xmonad.hs is ready to be used.
 

$(realpath $(SESSION)):
	# Generate a desktop file for you.
	$(desktop) > $@
	
$(XSESSION_DIR)/$(SESSION): $(realpath $(SESSION))
	# Link your desktop file into the system's include area.
	sudo ln -s $^ $@

$(HOME)/bin/xmonad.start: startups/xmonad.start
	# Give yourself a start script.  Used by the desktop file.
	mkdir -p $(@D)
	cp -v $^ $@

$(HOME)/.xmonad/xmonad.hs: xmonad.hs
	# Default, stock, xmonad config.
	mkdir -p $(@D)
	cp -v $^ $@

#####
# EOF
