# WARNING: uses GNU make
# path of . relative to $HOME
DOTPATH ?= .dotfiles

.PHONY: claude
claude: ~/.claude/CLAUDE.md ~/.claude/settings.json

~/.claude/CLAUDE.md: claude/CLAUDE.md
	install -m644 $< $@

~/.claude/settings.json: claude/settings.json
	install -m644 $< $@

.PHONY: zsh
zsh: ~/.zsh ~/.zshrc ~/.zlogout

~/.zsh:
	ln -sf $(DOTPATH)/zsh $@

~/.zshrc: ~/.zsh
	ln -sf .zsh/zshrc $@

~/.zlogout: ~/.zsh
	ln -sf .zsh/zlogout $@

.PHONY: vim
vim: ~/.vim

~/.vim:
	ln -sf $(DOTPATH)/vim $@

.PHONY: nvim
nvim: ~/.config/nvim/init.vim

~/.config/nvim/init.vim: init.vim
	mkdir -p $(dir $@)
	ln -sf ../../$(DOTPATH)/$< $@

.PHONY: nvimpager
nvimpager: ~/.config/nvimpager/init.vim

~/.config/nvimpager/init.vim: vim/vimpagerrc
	mkdir -p $(dir $@)
	ln -sf ../../$(DOTPATH)/$< $@

.PHONY: tmux
tmux: ~/.tmux.conf

~/.tmux.conf: tmux.conf
	ln -sf $(DOTPATH)/$< $@

.PHONY: git
git: ~/.config/git/config

~/.config/git/config: gitconfig
	mkdir -p $(dir $@)
	install -m644 $< $@

.PHONY: mpv
mpv: ~/.config/mpv/mpv.conf

~/.config/mpv/mpv.conf: mpv.conf
	mkdir -p $(dir $@)
	install -m644 $< $@

.PHONY: xmonad xmobar
xmonad: ~/.xmonad/xmonad.hs ~/.xmonad/lib ~/bin/i3lock_wrapper

xmobar: ~/.xmobar/xmobar.hs ~/.xmobar/lib

~/.xmonad/xmonad.hs: xmonad-xmobar/xmonad-$(HOSTNAME).hs
	install -m644 $< $@

~/.xmonad/lib: xmonad-xmobar/lib
	ln -sf ../$(DOTPATH)/$< $@

~/bin/i3lock_wrapper: xmonad-xmobar/i3lock_wrapper
	install -m700 $< $@

~/.xmobar/xmobar.hs: xmonad-xmobar/xmobar-$(HOSTNAME).hs
	install -m644 $< $@

~/.xmobar/lib: xmonad-xmobar/lib
	ln -sf ../$(DOTPATH)/$< $@

xmodmap: ~/.Xmodmap

~/.Xmodmap: Xmodmap
	install -m644 $< $@
