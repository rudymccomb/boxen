umask 002
export HISTFILESIZE=10000

export GREP_OPTIONS="--color=always"
export NODE_PATH=/opt/local/bin/node

alias ls="ls -G"
alias less="less -R"

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

source ~/bin/git-prompt
source /opt/boxen/env.sh

# Ez akkor bebikazza az agentet
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initializing new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
    echo succeeded
    chmod 600 ${SSH_ENV}
    . ${SSH_ENV} > /dev/null
    /usr/bin/ssh-add;
}

if [ -f "${SSH_ENV}" ]; then
    . ${SSH_ENV} > /dev/null
    ps -x | grep "^ *${SSH_AGENT_PID}" | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

#
