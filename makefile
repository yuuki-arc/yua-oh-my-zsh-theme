# Installs a copy of the theme on the folder `~/.oh-my-zsh/themes/`
install:
	cp ./yua.zsh-theme ~/.oh-my-zsh/themes/yua.zsh-theme

# Symlinks the theme for easier development
link:
	ln -sF `pwd`/yua.zsh-theme ~/.oh-my-zsh/themes/
