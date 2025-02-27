WHICH=$(/usr/bin/env which which)
EDITOR=editor
VISUAL=${EDITOR}

HISTFILE=~/.history
HOSTNAME="$(hostname -s)"
LANG="en_US.UTF-8"
LESSHISTFILE=
OLDMAIL="${MAIL}"
MAIL=""
PAGER="less -iX"
SSH="$(which ssh)"
TMUX_SOCK=~/.tmux/socks/default

export EDITOR HISTFILE HOSTNAME LANG LESSHISTFILE 
export MAIL OLDMAIL PAGER TMUX_SOCK
unset WHICH

# CVS.
CVSEDITOR="${EDITOR}"
CVS_RSH=/usr/bin/ssh

export CVSEDITOR CVS_RSH

# Functions.
addto () {
    local STRING="$1"
    local NEW="$2"
    local AFTER="$3"
    case "${STRING}" in
        ${NEW}|${NEW}:*|*:${NEW}|*:${NEW}:*);;
        *) [ "${AFTER}" = "after" ] && STRING="${STRING}:${NEW}" || STRING="${NEW}:${STRING}" ;;
    esac
    echo ${STRING}
}

addtopath () {
    local item="$1"
    [ -d "$item" -a -x "$item" ] || return
    export PATH="$(addto "$item" "$PATH")"
}

sshagent () {
    . "${HOME}"/bin/sshagent
}

gpgagent () {
    . "${HOME}"/bin/gpgagent
}

site () {
    if [ -z "$1" ]; then
        echo "${SITE}"
    else
        SITE=$1; export SITE
        . ~/.profile
    fi
}

# Aliases.
alias curl="curl -s"
alias dc="cd"
alias less="${PAGER}"
alias list="tmux ls"
alias ls="ls -F"
alias pydoc="python -m pydoc"
alias json="python -m json.tool"
alias sudo='A=`alias` /usr/bin/sudo '
alias tmux="tmux -S ${TMUX_SOCK}"
alias vi="${VISUAL}"
alias vimdiff="vimdiff -o"

#eval "$(hub alias -s)"
alias git=~/bin/hub
alias add="git add"
alias branch="git branch"
alias ca="git ca"
alias ci="git commit"
alias clone="git clone"
alias co="git checkout"
alias init="git init"
alias log="git log"
alias merge="git merge"
alias pull="git pull"
alias push="git push"
alias review="git review"
alias st="git st"
alias status="git status"

PATH=""
path="
$HOME/bin
$HOME/Library/Haskell/bin
/usr/texbin
/usr/local/bin
/usr/local/sbin
/bin
/sbin
/usr/X11/bin
/usr/X11R6/bin
/usr/bin
/usr/games
/usr/local/bin
/usr/sbin
/usr/texbin
"
for d in $path; do addtopath $d; done

libs="
$HOME/lib
"
for d in $libs; do [ -d "$d" ] && export LD_LIBRARY_PATH=$(addto "$LD_LIBRARY_PATH" "$d"); done

# Apply site-specific settings.
export GIT_EDITOR=emacsclient
GIT_COMMITTER_NAME="Will Maier"
case "${SITE}" in
    simple) HGUSER="Will Maier <will@simple.com>"
            GIT_COMMITTER_EMAIL="will@simple.com"
            ;;
    *)      HGUSER="Will Maier <wcmaier@m.aier.us>"
            GIT_COMMITTER_EMAIL="wcmaier@m.aier.us"
            ;;
esac
GIT_AUTHOR_NAME=$GIT_COMMITTER_NAME
GIT_AUTHOR_EMAIL=$GIT_COMMITTER_EMAIL
export HGUSER GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL

# Set SSH_CLIENT_NAME after host has set up callback, if necessary.
SSH_CLIENT_NAME="${HOSTNAME}"
export SSH_CLIENT_NAME

# Virtualenv.
OLDPS1="$PS1"
if [ -r "${HOME}/bin/activate" ]; then
    . "${HOME}/bin/activate"
fi
if [ -n "$OLDPS1" ]; then
    export PS1="$OLDPS1"
else
    unset PS1
fi

# rbenv
#which rbenv > /dev/null 2>&1 && eval "$(rbenv init -)"

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
chruby 1.9.3-p194

# Local::lib
if [ -d "${HOME}/perl5/lib/perl5" ]; then
    eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)
fi

export GOPATH=$HOME

sshagent
gpgagent

ulimit -n 1023

case "$SHELL" in
    *ksh*) export ENV=~/.kshrc;;
    *zsh*) export ENV=~/.zshrc;;
esac
