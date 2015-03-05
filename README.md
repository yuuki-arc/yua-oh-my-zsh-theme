# yua zsh Theme for oh-my-zsh ![Travis CI](https://travis-ci.org/yuuki-arc/yua-oh-my-zsh-theme.svg)

This theme is a [oh-my-zsh shell](https://github.com/robbyrussell/oh-my-zsh) theme
to customized [Bullet Train for oh-my-zsh](https://github.com/caiogondim/bullet-train-oh-my-zsh-theme).

It currently shows:
- Current Ruby version and gemset, through rbenv
- Current Node.js version, through NVM
- Git status
- Timestamp
- Current directory
- Background jobs
- Exit code of last command

## Preview

![Preview]()


## Requirements

In order to use the theme, you will first need:

* [Vim Powerline patched](https://github.com/Lokaltog/powerline-fonts)
* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* Make sure terminal is using 256-colors mode with `export TERM="xterm-256color"`
* For [iTerm 2](http://iterm2.com/) users, make sure you go into your settings and set both the regular font and the non-ascii font to powerline fonts or the prompt separators and special characters will not display correctly.


## Installing

### For oh-my-zsh users

1. Download the theme [here](http://raw.github.com/yuuki-arc/yua-oh-my-zsh-theme/master/yua.zsh-theme)
2. Put the file **yua.zsh-theme** in **~/.oh-my-zsh/themes/**
3. Configure the theme in your **~/.zshrc** file:

```bash
ZSH_THEME="yua"
```

### For antigen users

Add the following snippet to your **.zshrc** somewhere after the line
`antigen use oh-my-zsh`.

```bash
antigen theme https://github.com/yuuki-arc/yua-oh-my-zsh-theme yua
```

### For Zgen users

If you're using [zgen](https://github.com/tarjoilija/zgen), add the following line to your **~/.zshrc** where you're adding your other zsh plugins.

```bash
zgen load yuuki-arc/yua-oh-my-zsh-theme
```

## References
- [Bullet Train for oh-my-zsh](https://github.com/caiogondim/bullet-train-oh-my-zsh-theme)
- [zsh Advent Calendar 2012 / day 11th - Qiita](http://qiita.com/mollifier/items/8d5a627d773758dd8078)

## License
The MIT License (MIT)

Copyright (c) 2015 [yuuki-arc](http://yuukiar.co)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
