export PATH="$HOME/.bin:$PATH:/usr/local/sbin:/usr/sbin:/sbin"

# Uncomment below to have teminal windows open shell in tmux on creation
#if [ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ] && [ "${__CFBundleIdentifier}" != 'com.microsoft.VSCode' ] && [ -t 0 ] && [ -z "$TMUX" ] && which tmux >/dev/null 2>&1; then
#  tmux attach || tmux
#fi

# Shortcut to reload .bashrc
alias .rc='. ~/.bashrc'

# check whether the previous command succeeded (outputs 0) or failed (outputs anything but 0)
alias sup='echo $?'

# go up one or multiple directories: typing .. will go up 1 dir, typing .2, .3, ... .9 will go the relevant number of directories up
alias ..='cd ..'
up=..
for i in $(seq 2 9); do
  up="$up/.."
  alias ".$i=cd $up"
done
up=

# use vim as the default editor
export EDITOR=vim
set -o vi

# open multiple files in tabs by default
alias vim='vim -p'

# ll to show all files with all the details
alias ll='ls -al'

# highlight found patterns when searching with grep
alias grep='grep --color'

# grep recursively, skipping directories you never want to grep in
function gr {
  grep --color -r --exclude-dir=.git --exclude-dir=.ijwb --exclude-dir=.vscode --exclude-dir=__pycache__ --exclude-dir=.mypy_cache -I "$@" .
}

# copy input into the paste buffer
alias pbcopy='xclip -selection c -i'
# print out the contents of the paste buffer
alias pbpaste='xclip -selection c -o'

# aliases for the most commonly used git commands
# git status
function st {
  git st "$@"
}
# pretty git log (run `git conf` to see the details)
function lg {
  git lg "$@"
}
# git checkout
function co {
  git co "$@"
}
# git branch
function branch {
  git branch "$@"
}
# git fetch to synchronize your repo with the upstream
function fetch {
  git fetch "$@"
}
# rebase your branch onto the latest upstream
function rebase {
  git rebase origin/main
}
# git checkout the latest upstream
function gm {
  git co origin/main
}
