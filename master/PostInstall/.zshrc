# Greeting
echo "Hi Zumkato, Welcome to Parrot OS Hack All The Things!"

# Prompt
PROMPT="%F{red}┌[%f%F{cyan}%m%f%F{red}]─[%f%F{yellow}%D{%H:%M-%d/%m}%f%F{red}]─[%f%F{magenta}%d%f%F{red}]%f"$'\n'"%F{red}└╼%f%F{green}$USER%f%F{yellow}$%f"
# Export PATH$
export PATH=~/.local/bin:/snap/bin:/usr/sandbox/:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/share/games:/usr/local/sbin:/usr/sbin:/sbin:$PATH

# alias
alias ls='ls -lh --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'


# Save type history for completion and easier life
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Useful alias for benchmarking programs
# require install package "time" sudo apt install time
# alias time="/usr/bin/time -f '\t%E real,\t%U user,\t%S sys,\t%K amem,\t%M mmem'"
# Display last command interminal
echo -en "\e]2;Matrix Terminal\a"
preexec () { print -Pn "\e]0;$1 - Matrix Terminal\a" }

setopt interactivecomments
setopt ignoreeof
setopt correctall
setopt globdots
setopt auto_cd

if [[ ! -d ~/.zplug ]];then
  git clone https://github.com/zplug/zplug ~/.zplug
fi
source ~/.zplug/init.zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/dotenv", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/osx", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load --verbose


source $HOME/.bash_aliases
#if ([[ -z "$TMUX" && -n "$SSH_CONNECTION" ]]); then /usr/bin/tmux attach || /usr/bin/tmux new; fi
MSF_DATABASE_CONFIG=/usr/share/metasploit-framework/config/database.yml

