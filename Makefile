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
	gconftool --type boolean --set /apps/nautilus/preferences/show_desktop false

show-nautilus-desktop:
	gconftool --type boolean --set /apps/nautilus/preferences/show_desktop true

install: $(XSESSION_DIR)/$(SESSION) \
				 $(HOME)/.xmonad/xmonad.hs  \
				 hide-nautilus-desktop      \
         check-xmonad
	# If your xmonad.hs is ready, cp xmonad.start ~/bin/
	# It should be available as $(SESSION) in the sessions list when you select
	# your user name in GDM.

desktop: $(realpath $(SESSION))
	$(desktop)

check-xmonad:
	$(check)
	# If $(check) printed nothing, your xmonad.hs is ready to be used.
 

$(realpath $(SESSION)):
	$(desktop) > $@
	
$(XSESSION_DIR)/$(SESSION): $(realpath $(SESSION))
	sudo ln -s $^ $@

$(HOME)/.xmonad/xmonad.hs: xmonad.hs
	mkdir -p $(@D)
	cp -v $^ $@

#####
# EOF
