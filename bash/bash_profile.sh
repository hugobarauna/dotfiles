export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;33"
export CLICOLOR="auto"

export EDITOR='vim'

completion="$(brew --prefix)/etc/bash_completion"
if [ -f $completion ]; then
  . $completion
fi

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1

# Bash prompt
PS1='\[\033[0;32m\]\w ' # current directory
PS1+='\[\033[1;36m\]$(__git_ps1 "[%s]")' # git prompt
PS1+='\n'
#t PS1+='\[\033[1;37\]\$ \[\033[0m\]' # regular user or root user

#------------------#
#-PERSONAL ALIASES-#
#------------------#

# Git
alias g="git"
alias gco="git checkout"
alias gst="git status"
alias gad="git add"
alias gci="git commit"
alias gdf="git diff"
alias gdc="git diff --cached"

# Rails
alias ss="ruby script/server"
alias sc="ruby script/console"
alias tld="tail -f log/development.log"
alias tlt="tail -f log/test.log"

alias be="bundle exec"

# Directories
alias src="cd ~/src"
alias dotfiles="cd ~/.dotfiles"
alias brewfile="cd ~/.homebrew-brewfile"

# Files
alias todolist="vim ~/Desktop/todo-list-personal.md"

# Check internet connection
alias puol="ping uol.com.br"
alias ppnet="ping 10.0.1.1"

# My book
alias lint-my-book="/Users/hugobarauna/projects/tubaina-jarvis/jarvis lint --afc-path=/Users/hugobarauna/projects/meulivro/livro/book/"
alias build-book="sh /Users/hugobarauna/projects/meulivro/build_book.sh"
alias download-book="ruby /Users/hugobarauna/projects/meulivro/download_book.rb"
alias open-book="(cd /Users/hugobarauna/projects/meulivro && cat .last_version.txt | xargs open)"
alias todo="ag '\[TODO (?:[^HB]{2})' ."
alias meulivro="cd /Users/hugobarauna/projects/meulivro"

# fancy cat command
alias c="pygmentize -O style=monokai -f console256 -g"

# HTTP GET to an endpoint that answers with json
alias jsonget="curl -X GET -H 'Accept: application/json'"

# Openining a firefox window from a remote X server inside a vagrant machine
# alias fv="xinit -e ssh -X fiat-vagrant firefox -height 768 -width 1280 -chrome"


#------------------#
#---PATH CHANGES---#
#------------------#

# Oracle
# export DYLD_LIBRARY_PATH=/opt/oracle/instantclient_10_2:$DYLD_LIBRARY_PATH
# export DYLD_FALLBACK_LIBRARY_PATH=/opt/oracle/instantclient_10_2:DYLD_FALLBACK_LIBRARY_PATH
# export TNS_ADMIN=/opt/oracle/instantclient_10_2/network/admin

# Octave
# export PATH=$PATH:/Applications/Octave.app/Contents/Resources/bin

# bundler bin stubs
export PATH=./bin:./b:$PATH

# add ~/bin to PATH
export PATH=~/bin:$PATH

# add GO related dirs to PATH
export GOPATH=~/golang
export PATH=$PATH:$GOPATH/bin

CDPATH=".:~:~/src"

source ~/bin/functions.sh
# source ~/.autocomplete-ssh.sh

eval "$(rbenv init -)"
eval "$(nodenv init -)"
