# README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
#
# In addition, I recommend the
# [Japanesque theme](https://github.com/aereal/dotfiles/tree/master/colors/Japanesque) and, if
# you're using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over
# Terminal.app - it has significantly better color fidelity.

# ------------------------------------------------------------------------------
# CONFIGURATION
# The default configuration, that can be overwrite in your .zshrc file
# ------------------------------------------------------------------------------

VIRTUAL_ENV_DISABLE_PROMPT=true

# PROMPT
YUA_PROMPT_CHAR="\$"
YUA_PROMPT_ROOT=true
YUA_IS_SSH_CLIENT=true

# STATUS
YUA_STATUS_SHOW=true
YUA_STATUS_EXIT_SHOW=false
YUA_STATUS_BG=green
YUA_STATUS_ERROR_BG=red
YUA_STATUS_FG=white

# TIME
YUA_TIME_SHOW=true
YUA_TIME_BG=white
YUA_TIME_FG=black

# VIRTUALENV
YUA_VIRTUALENV_SHOW=true
YUA_VIRTUALENV_BG=yellow
YUA_VIRTUALENV_FG=white
YUA_VIRTUALENV_PREFIX=🐍

# NVM
YUA_NVM_SHOW=false
YUA_NVM_BG=green
YUA_NVM_FG=white
YUA_NVM_PREFIX="⬡"

# RMV
YUA_RVM_SHOW=true
YUA_RVM_BG=magenta
YUA_RVM_FG=white
YUA_RVM_PREFIX=♦️

# DIR
YUA_DIR_SHOW=true
YUA_DIR_BG=cyan
YUA_DIR_FG=white
YUA_DIR_CONTEXT_SHOW=false
YUA_DIR_EXTENDED=true

# GIT
YUA_GIT_SHOW=true
YUA_GIT_BG=white
YUA_GIT_FG=black
YUA_GIT_EXTENDED=true

# CONTEXT
YUA_CONTEXT_SHOW=false
YUA_CONTEXT_BG=black
YUA_CONTEXT_FG=default

# GIT PROMPT
ZSH_THEME_GIT_PROMPT_PREFIX=" \ue0a0 "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" ✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" ✔"
ZSH_THEME_GIT_PROMPT_ADDED=" %F{green}✚%F{black}"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %F{blue}✹%F{black}"
ZSH_THEME_GIT_PROMPT_DELETED=" %F{red}✖%F{black}"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %F{yellow}✭%F{black}"
ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
ZSH_THEME_GIT_PROMPT_AHEAD=" ⬆"
ZSH_THEME_GIT_PROMPT_BEHIND=" ⬇"
ZSH_THEME_GIT_PROMPT_DIVERGED=" ⬍"

# ------------------------------------------------------------------------------
# SEGMENT DRAWING
# A few functions to make it easy and re-usable to draw segmented prompts
# ------------------------------------------------------------------------------

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# ------------------------------------------------------------------------------
# PROMPT COMPONENTS
# Each component will draw itself, and hide itself if no information needs
# to be shown
# ------------------------------------------------------------------------------

# Context: user@hostname (who am I and where am I)
context() {
  local user="$(whoami)"
  [[ "$user" != "$YUA_CONTEXT_DEFAULT_USER" || -n "$YUA_IS_SSH_CLIENT" ]] && echo -n "${user}@%m"
}
prompt_context() {
  [[ $YUA_CONTEXT_SHOW == false ]] && return

  local _context="$(context)"
  [[ -n "$_context" ]] && prompt_segment $YUA_CONTEXT_BG $YUA_CONTEXT_FG "$_context"
}

# Git
prompt_git() {
  if [[ $YUA_GIT_SHOW == false ]] then
    return
  fi

  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    prompt_segment $YUA_GIT_BG $YUA_GIT_FG

    if [[ $YUA_GIT_EXTENDED == true ]] then
      echo -n $(git_prompt_info)$(git_prompt_status)
    else
      echo -n $(git_prompt_info)
    fi
  fi
}

prompt_hg() {
  local rev status
  if $(hg id >/dev/null 2>&1); then
    if $(hg prompt >/dev/null 2>&1); then
      if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
        # if files are not added
        prompt_segment red white
        st='±'
      elif [[ -n $(hg prompt "{status|modified}") ]]; then
        # if any modification
        prompt_segment yellow black
        st='±'
      else
        # if working copy is clean
        prompt_segment green black
      fi
      echo -n $(hg prompt "☿ {rev}@{branch}") $st
    else
      st=""
      rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      branch=$(hg id -b 2>/dev/null)
      if $(hg st | grep -Eq "^\?"); then
        prompt_segment red black
        st='±'
      elif $(hg st | grep -Eq "^(M|A)"); then
        prompt_segment yellow black
        st='±'
      else
        prompt_segment green black
      fi
      echo -n "☿ $rev@$branch" $st
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
  if [[ $YUA_DIR_SHOW == false ]] then
    return
  fi

  local dir=''
  local _context="$(context)"
  [[ $YUA_DIR_CONTEXT_SHOW == true && -n "$_context" ]] && dir="${dir}${_context}:"
  [[ $YUA_DIR_EXTENDED == true ]] && dir="${dir}%4(c:...:)%3c" || dir="${dir}%1~"
  prompt_segment $YUA_DIR_BG $YUA_DIR_FG $dir
}

# RVM: only shows RVM info if on a gemset that is not the default one
prompt_rvm() {
  if [[ $YUA_RVM_SHOW == false ]] then
    return
  fi

  if which rvm-prompt &> /dev/null; then
    if [[ ! -n $(rvm gemset list | grep "=> (default)") ]]
      then
      prompt_segment $YUA_RVM_BG $YUA_RVM_FG $YUA_RVM_PREFIX"  $(rvm-prompt i v g)"
    fi
  fi
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  if [[ $YUA_VIRTUALENV_SHOW == false ]] then
    return
  fi

  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment $YUA_VIRTUALENV_BG $YUA_VIRTUALENV_FG $YUA_VIRTUALENV_PREFIX"  $(basename $virtualenv_path)"
  fi
}

# NVM: Node version manager
prompt_nvm() {
  if [[ $YUA_NVM_SHOW == false ]] then
    return
  fi

  [[ $(which nvm) != "nvm not found" ]] || return
  local nvm_prompt
  nvm_prompt=$(node -v 2>/dev/null)
  [[ "${nvm_prompt}x" == "x" ]] && return
  nvm_prompt=${nvm_prompt:1}
  prompt_segment $YUA_NVM_BG $YUA_NVM_FG $YUA_NVM_PREFIX$nvm_prompt
}

prompt_time() {
  if [[ $YUA_TIME_SHOW == false ]] then
    return
  fi

  prompt_segment $YUA_TIME_BG $YUA_TIME_FG %D{%H:%M:%S}
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  if [[ $YUA_STATUS_SHOW == false ]] then
    return
  fi

  local symbols
  symbols=()
  [[ $RETVAL -ne 0 && $YUA_STATUS_EXIT_SHOW != true ]] && symbols+="✘"
  [[ $RETVAL -ne 0 && $YUA_STATUS_EXIT_SHOW == true ]] && symbols+="✘ $RETVAL"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡%f"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="⚙"

  if [[ -n "$symbols" && $RETVAL -ne 0 ]] then
    prompt_segment $YUA_STATUS_ERROR_BG $YUA_STATUS_FG "$symbols"
  elif [[ -n "$symbols" ]] then
    prompt_segment $YUA_STATUS_BG $YUA_STATUS_FG "$symbols"
  fi

}

# Prompt Character
prompt_char() {
  local bt_prompt_char

  if [[ ${#YUA_PROMPT_CHAR} -eq 1 ]] then
    bt_prompt_char="${YUA_PROMPT_CHAR}"
  fi

  if [[ $YUA_PROMPT_ROOT == true ]] then
    bt_prompt_char="%(!.%F{red}#.%F{green}${bt_prompt_char}%f)"
  fi

  echo -n $bt_prompt_char
}

# ------------------------------------------------------------------------------
# PROMPT COMPONENTS (vcs_info)
# prompt_git Hook Function
# ------------------------------------------------------------------------------
# vcs_info 設定

autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload -Uz is-at-least
autoload -Uz colors

#＠＠＠プロンプト右側部分
# 以下の3つのメッセージをエクスポートする
#   $vcs_info_msg_0_ : 通常メッセージ用 (緑)
#   $vcs_info_msg_1_ : 警告メッセージ用 (黄色)
#   $vcs_info_msg_2_ : エラーメッセージ用 (赤)
zstyle ':vcs_info:*' max-exports 3

zstyle ':vcs_info:*' enable git svn hg bzr
# 標準のフォーマット(git 以外で使用)
# misc(%m) は通常は空文字列に置き換えられる
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b]' '%m' '<!%a>'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true


if is-at-least 4.3.10; then
  # git 用のフォーマット
  # git のときはステージしているかどうかを表示
  zstyle ':vcs_info:(git|git-svn):*' formats '(%s)-[%b]' '%c%u %m %S/%r'
  zstyle ':vcs_info:(git|git-svn):*' actionformats '(%s)-[%b]' '%c%u %m' '<!%a> %S/%r'
  zstyle ':vcs_info:(git|git-svn):*' check-for-changes true
  zstyle ':vcs_info:(git|git-svn):*' stagedstr "+"    # %c で表示する文字列
  zstyle ':vcs_info:(git|git-svn):*' unstagedstr "-"  # %u で表示する文字列
fi

# hooks 設定
if is-at-least 4.3.11; then

    # フックの最初の関数
    # git の作業コピーのあるディレクトリのみフック関数を呼び出すようにする
    # (.git ディレクトリ内にいるときは呼び出さない)
    # .git ディレクトリ内では git status --porcelain などがエラーになるため
    function +vi-git-hook-begin() {
      if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
        # 0以外を返すとそれ以降のフック関数は呼び出されない
        return 1
      fi

      return 0
    }

    # untracked ファイル表示
    #
    # untracked ファイル(バージョン管理されていないファイル)がある場合は
    # unstaged (%u) に ? を表示
    function +vi-git-untracked() {
      # zstyle formats, actionformats の2番目のメッセージのみ対象にする
      if [[ "$1" != "1" ]]; then
        return 0
      fi

      if command git status --porcelain 2> /dev/null \
        | awk '{print $1}' \
        | command grep -F '??' > /dev/null 2>&1 ; then

        # unstaged (%u) に追加
        hook_com[unstaged]+='?'
      fi
    }

    # push していないコミットの件数表示
    #
    # リモートリポジトリに push していないコミットの件数を
    # pN という形式で misc (%m) に表示する
    function +vi-git-push-status() {
      # zstyle formats, actionformats の2番目のメッセージのみ対象にする
      if [[ "$1" != "1" ]]; then
        return 0
      fi

      if [[ "${hook_com[branch]}" != "master" ]]; then
        # master ブランチでない場合は何もしない
        return 0
      fi

      # push していないコミット数を取得する
      local ahead
      ahead=$(command git rev-list origin/master..master 2>/dev/null \
      | wc -l \
      | tr -d ' ')

      if [[ "$ahead" -gt 0 ]]; then
        # misc (%m) に追加
        hook_com[misc]+="(p${ahead})"
      fi
    }

    # マージしていない件数表示
    #
    # master 以外のブランチにいる場合に、
    # 現在のブランチ上でまだ master にマージしていないコミットの件数を
    # (mN) という形式で misc (%m) に表示
    function +vi-git-nomerge-branch() {
      # zstyle formats, actionformats の2番目のメッセージのみ対象にする
      if [[ "$1" != "1" ]]; then
        return 0
      fi

      if [[ "${hook_com[branch]}" == "master" ]]; then
        # master ブランチの場合は何もしない
        return 0
      fi

      local nomerged
      nomerged=$(command git rev-list master..${hook_com[branch]} 2>/dev/null | wc -l | tr -d ' ')

      if [[ "$nomerged" -gt 0 ]] ; then
        # misc (%m) に追加
        hook_com[misc]+="(m${nomerged})"
      fi
    }

    # とりあえず実装
    function +vi-git-nomerge-master() {
      # vcs_info_msg_1_ を設定する場合のみ処理の対象とする
      if [[ "$1" != "1" ]]; then
        return 0
      fi

      # master ブランチにいる時はなにもしない
      if [[ "${hook_com[branch]}" == "master" ]]; then
        return 0
      fi

      # 現在のブランチにまだマージしていないブランチ一覧を取得する。
      # その中に master が含まれていた場合、 master は現在のブランチにマージ済みでないとみなす
      if command git branch --no-merged 2>/dev/null | command grep 'master' > /dev/null 2>&1 ; then
        hook_com[misc]+="(R)"
      fi
    }


    # stash 件数表示
    #
    # stash している場合は :SN という形式で misc (%m) に表示
    function +vi-git-stash-count() {
      # zstyle formats, actionformats の2番目のメッセージのみ対象にする
      if [[ "$1" != "1" ]]; then
        return 0
      fi

      local stash
      stash=$(command git stash list 2>/dev/null | wc -l | tr -d ' ')
      if [[ "${stash}" -gt 0 ]]; then
        # misc (%m) に追加
        hook_com[misc]+=":S${stash}"
      fi
    }

fi

function _update_vcs_info_msg() {
  local -a messages
  local prompt

  LANG=en_US.UTF-8 vcs_info

  if [[ -z ${vcs_info_msg_0_} ]]; then
    # vcs_info で何も取得していない場合はプロンプトを表示しない
    prompt=""
  else
    # vcs_info で情報を取得した場合
    # $vcs_info_msg_0_ , $vcs_info_msg_1_ , $vcs_info_msg_2_ を
    # それぞれ緑、黄色、赤で表示する
    [[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{green}${vcs_info_msg_0_}%f" )
    [[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
    [[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )

    # 間にスペースを入れて連結する
    prompt="${(j: :)messages}"
  fi
}
add-zsh-hook precmd _update_vcs_info_msg

# ------------------------------------------------------------------------------
# MAIN
# Entry point
# ------------------------------------------------------------------------------

build_prompt() {
  RETVAL=$?
  prompt_time
  prompt_status
  prompt_rvm
  prompt_virtualenv
  prompt_nvm
  prompt_context
  prompt_dir
  prompt_git
  # prompt_hg
  prompt_end
}

PROMPT='
%{%f%b%k%}$(build_prompt)
%{${fg_bold[default]}%}$(prompt_char) %{$reset_color%}'
