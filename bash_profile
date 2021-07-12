#!/bin/bash
. ~/.bashrc

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
# source /usr/local/miniconda3/etc/profile.d/conda.sh  # commented out by conda initialize
# . /usr/local/miniconda3/etc/profile.d/conda.sh  # commented out by conda initialize

## >>> conda initialize >>>
## !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/Users/cue/devtools/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/Users/cue/devtools/miniconda3/etc/profile.d/conda.sh" ]; then
#        source /Users/cue/devtools/miniconda3/etc/profile.d/conda.sh
#    else
#        export PATH="/Users/cue/devtools/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
## <<< conda initialize <<<

[ -s "/Users/cue/.web3j/source.sh" ] && source "/Users/cue/.web3j/source.sh"
