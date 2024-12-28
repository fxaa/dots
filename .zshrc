# vim: set fdm=marker:

# path {{{
BINDIRS=(
        /opt/homebrew/bin
        /usr/local/bin
        $HOME/.cargo/bin
        $HOME/.toolbox/bin
	$HOME/.local/share/mise/shims
)

for BINDIR in "${BINDIRS[@]}"
do
        export PATH=$BINDIR:$PATH
done
### }}}
# variables {{{
export MOCWORD_DATA=~/.local/mocword.sqlite

export EDITOR=nvim
export VISUAL=nvim
export NODE_OPTIONS="--max_old_space_size=8192 --openssl-legacy-provider"
export NODE_GYP_FORCE_PYTHON=~/.local/share/mise/installs/python/3.10/bin/python3.10
# brew shellenv results
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
# }}}
# zsh {{{
setopt no_beep
setopt brace_ccl
setopt hist_ignore_dups
setopt extended_history
setopt hist_expand
setopt long_list_jobs
setopt mark_dirs

ZSH_AUTOSUGGEST_STRATEGY=( completion history )
ZSH_AUTOSUGGEST_HISTORY_IGNORE="(cd *|git *)"
ZSH_AUTOSUGGEST_COMPLETION_IGNORE="git *"
ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )

# compinstall stuff
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+r:|[._-]=** r:|=**'
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' prompt '%e chars away from something i know'
zstyle :compinstall filename '~/.zshrc'
# end compinstall
autoload -Uz compinit && compinit -C
autoload -U colors && colors
# }}}
# utils {{{
source ~/.shell/util.zsh
source /Users/dlewisn/.brazil_completion/zsh_completion

if [ -x ~/.local/share/sheldon ]; then
    if ! [ -f /tmp/sheldon.cache ]; then
	sheldon source > /tmp/sheldon.cache
	zcompile /tmp/sheldon.cache
    fi
    source /tmp/sheldon.cache
fi
if [ -x ~/.local/bin/mise ]; then
    if ! [ -f /tmp/mise.cache ]; then
	~/.local/bin/mise activate zsh > /tmp/mise.cache
	zcompile /tmp/mise.cache
    fi
    source /tmp/mise.cache
fi
# }}}
# brazil aliases {{{
alias bb=brazil-build
alias brc='brazil-recursive-cmd'
alias bws='brazil ws'
alias bbr='brc brazil-build'
# }}}
# git aliases {{{
alias gitau="git update-index --assume-unchanged"
alias logadog="git log --color --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit ; echo \"A parting dog for your troubles: 🐕\""
alias gits="git status"
alias gitc="git checkout"
alias gitb="git branch"
# }}}
# cli aliases {{{
alias dots='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'
alias vim=nvim
alias ks="kitten ssh"
alias dircolors=gdircolors
alias isonow='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias morning='kinit -f && mwinit -f -s'
# }}}

