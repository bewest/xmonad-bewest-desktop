########################################################
#
# Used to manage my xmonad config.
#
#


XSESSION_DIR=/usr/share/xsessions
SESSION=bewest-xmonad.desktop


install: $(XSESSION_DIR)/$(SESSION)  ~/.xmonad/xmonad.hs
	

$(XSESSION_DIR)/$(SESSION): $(realpath $(SESSION))
	sudo ln -s $^ $@

~/.xmonad/xmonad.hs: xmonad.hs
	mkdir -p $(@D)
	cp -v $^ $@

#####
# EOF
