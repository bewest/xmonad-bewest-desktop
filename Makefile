########################################################
#
# Author: Ben West <bewest@gmail.com>
# Used to manage my xmonad config.
#
#


XSESSION_DIR=/usr/share/xsessions
SESSION=$(USER)-xmonad.desktop

enable:
	gconftool --type boolean --set /apps/nautilus/preferences/show_desktop true
disable:
	gconftool --type boolean --set /apps/nautilus/preferences/show_desktop false

install: $(XSESSION_DIR)/$(SESSION)  $(HOME)/.xmonad/xmonad.hs
	

$(XSESSION_DIR)/$(SESSION): $(realpath $(SESSION))
	sudo ln -s $^ $@

$(HOME)/.xmonad/xmonad.hs: xmonad.hs
	mkdir -p $(@D)
	cp -v $^ $@

#####
# EOF
