
#                         _               _              
#                        | |__   __ _ ___| |__  _ __ ___ 
#                        | '_ \ / _` / __| '_ \| '__/ __|
#                       _| |_) | (_| \__ \ | | | | | (__ 
#                      (_)_.__/ \__,_|___/_| |_|_|  \___|
#

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
eval "$(pyenv init -)"


# alias
alias less='less -M'

# alias
alias dir='dirs -v'
alias Doc='docker'
alias Find='find . -name '
alias Grep='grep -r'
alias Hist='history | grep'
alias Tags='gtags --gtagsconf=gtags.conf --gtagslabel=pygments --debug'
alias push='pushd'
alias pop='popd'
# grep -l -r $1 ./* | xargs sed -i.bak -e \'s/$1 /$2 /g\'
alias nv='nvim'
alias nvs='nvim -O'
alias nvt='nvim -p'
alias nvd='nvim -d'
alias vims='vim -O'
alias vimt='vim -p'
alias vimd='vimdiff'
alias MEMO='Nvim ~/memo.md'

# cd behavior
function cd {
    if [ -z "$1" ] ; then
        # Don't increase extra $ DIRSTACK with cd hits
        test "$PWD" != "$HOME" && pushd $HOME > /dev/null
    elif ( echo "$1" | egrep "^\.\.\.+$" > /dev/null ) ; then
        cd $( echo "$1" | perl -ne 'print "../" x ( tr/\./\./ - 1 )' )
    else
        pushd "$1" > /dev/null
    fi
}

# cd bookmark
function cj {
    ### cjはCDJ_DIR_MAPという環境変数の配列の定義が必要です
    # CDJ_DIR_MAP配列の例は以下です。ディレクトリのエイリアスと実ディレクトリのパスを空白区切りでペアで書いていきます
     export CDJ_DIR_MAP=(
         dbox ~/Dropbox
         cvs  ~/cvs
         etc  /etc
         );
    test -n "$DEBUG" && echo "DEBUG: dir arg=$arg #CDJ_DIR_MAP=${#CDJ_DIR_MAP[*]}"
    declare arg=$1 \
            subarg=$2 \
            dir i key value warn
    if [ -z "$arg" -o "$arg" = "-h" ] || [ "$arg" = "-v" -a -z "$subarg" ] ; then
        ### help and usage mode
        echo "Usage: $FUNCNAME <directory_alias>"
        echo "       $FUNCNAME [-h|-v|-l <directory_alias>]"
        echo "-h: help"
        echo "-l: list defined lists"
        echo "-v <directory_alias>: view path specify alias."
        return
    elif [ "$arg" = "-v" -o "$arg" = "-l" ] ; then
        ### view detail mode
        for (( i=0; $i<${#CDJ_DIR_MAP[*]}; i=$((i+2)) )) ; do
            key="${CDJ_DIR_MAP[$i]}"
            value="${CDJ_DIR_MAP[$((i+1))]}"
            if [ "$arg" = "-l" ] ; then
                if [ ! -d "$value" ] ; then
                    warn=" ***NOT_FOUND***"
                else
                    warn=""
                fi
                printf "%8s => %s%s\n" "$key" "$value" "$warn"
            elif [ "$arg" = "-v" ] ; then
                if [ "$key" = "$subarg" ] ; then
                    echo $value
                    return
                fi
            fi
        done
        return
    fi
    ### change directory mode
    for (( i=0; $i<${#CDJ_DIR_MAP[*]}; i=$((i+2)) )) ; do
        key="${CDJ_DIR_MAP[$i]}"
        value="${CDJ_DIR_MAP[$((i+1))]}"
        test -n "$DEBUG" && echo "$key => $value"
        if [ "$key" = "$arg" ] ; then
            if [ -n "$subarg" ] ; then
                dir="$value/$subarg"
            else
                dir="$value"
            fi
            cd "$dir"
            return
        fi
    done
    echo "directory alias \"$arg\" is not found"
    return 1
}

type cj >/dev/null 2>&1 &&
_cj()
{
    local cur prev opts i
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(for i in $(seq 0 2 $((${#CDJ_DIR_MAP[*]}-2)) ) ; do echo ${CDJ_DIR_MAP[$i]} ; done ; echo "-h -v -l")
    #echo ""
    #echo "> cur=$cur prev=$prev COMP_CWORD=$COMP_CWORD"
    #echo "> opts=$opts"
    #echo "> COMPWORDS=${COMP_WORDS[*]}"

    case ${prev} in
        -l)
            opts=$(for i in $(seq 0 2 $((${#CDJ_DIR_MAP[*]}-2)) ) ; do echo ${CDJ_DIR_MAP[$i]} ; done)
            COMPREPLY=( $(compgen -W "$opts" -- ${cur} ))
            return 0
            ;;
        *)
            ;;
    esac

    COMPREPLY=( $(compgen -W "$opts" -- ${cur} ))
    return 0
} &&
complete -F _cj cj

# 最近の cd によって移動したディレクトリを選択
function ch {
    local dirnum
    #dirs -v | head -n $(( LINES - 3 ))
    dirs -v | sort -k 2 | uniq -f 1 | sort -n -k 1 | head -n $(( LINES - 3 ))
    read -p "select number: " dirnum
    if [ -z "$dirnum" ] ; then
        echo "$FUNCNAME: Abort." 1>&2
    elif ( echo $dirnum | egrep '^[[:digit:]]+$' > /dev/null ) ; then
        cd "$( echo ${DIRSTACK[$dirnum]} | sed -e "s;^~;$HOME;" )"
    else
        echo "$FUNCNAME: Wrong." 1>&2
    fi
}

function cb {
    #popd $1 >/dev/null
    local num=$1 i
    if [ -z "$num" -o "$num" = 1 ] ; then
        popd >/dev/null
        return
    elif [[ "$num" =~ ^[0-9]+$ ]] ; then
        for (( i=0 ; i<num ; i++ )) ; do
            popd >/dev/null
        done
        return
    else
        echo "cb: argument is invalid." >&2
    fi
}

# 現在のディレクトリの中にあるディレクトリを番号指定で移動
function cl {
    local -a dirlist opt_f=false
    local i d num=0 dirnum opt opt_f
    while getopts ":f" opt ; do
        case $opt in
            f ) opt_f=true ;;
        esac
    done
    shift $(( OPTIND -1 ))
    dirlist[0]=..
    # external pipe scope. array is established.
    for d in * ; do test -d "$d" && dirlist[$((++num))]="$d" ; done
    # TODO: Is seq installed?
    for i in $( seq 0 $num ) ; do printf "%3d %s%b\n" $i "$( $opt_f && echo -n "$PWD/" )${dirlist[$i]}" ; done
    read -p "select number: " dirnum
    if [ -z "$dirnum" ] ; then
        echo "$FUNCNAME: Abort." 1>&2
    elif ( echo $dirnum | egrep '^[[:digit:]]+$' > /dev/null ) ; then
        cd "${dirlist[$dirnum]}"
    else
        echo "$FUNCNAME: Something wrong." 1>&2
    fi
}
