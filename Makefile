########################################################
#
# Author: Ben West <bewest@gmail.com>
# Used to manage my xmonad config.
#
#

XSESSION_DIR=/usr/share/xsessions
SESSION=$(USER)-xmonad.desktop
desktop=./xmonad-generate-desktop

hide-nautilus-desktop:
	gconftool --type boolean --set /apps/nautilus/preferences/show_desktop false

show-nautilus-desktop:
	gconftool --type boolean --set /apps/nautilus/preferences/show_desktop true

install: $(XSESSION_DIR)/$(SESSION) \
				 $(HOME)/.xmonad/xmonad.hs  \
				 hide-nautilus-desktop
	
desktop: $(realpath $(SESSION))
	$(desktop)

$(realpath $(SESSION)):
	$(desktop) > $@
	
$(XSESSION_DIR)/$(SESSION): $(realpath $(SESSION))
	sudo ln -s $^ $@

$(HOME)/.xmonad/xmonad.hs: xmonad.hs
	mkdir -p $(@D)
	cp -v $^ $@

#####
# EOF
