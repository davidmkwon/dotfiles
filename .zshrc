# Set SSH_AUTH_SOCK to the launchd-managed ssh-agent socket (com.openssh.ssh-agent).
export SSH_AUTH_SOCK=$(launchctl asuser $(id -u) launchctl getenv SSH_AUTH_SOCK)

# Load python shims
eval "$(pyenv init -)"

# Load ruby shims
eval "$(rbenv init -)"

# Add datadog devtools binaries to the PATH
export PATH="${HOME?}/dd/devtools/bin:${PATH?}"

# Point GOPATH to our go sources
export GOPATH="${HOME?}/go"

# Add binaries that are go install-ed to PATH
export PATH="${GOPATH?}/bin:${PATH?}"

# Point DATADOG_ROOT to ~/dd symlink
export DATADOG_ROOT="${HOME?}/dd"

# Tell the devenv vm to mount $GOPATH/src rather than just dd-go
export MOUNT_ALL_GO_SRC=1

# store key in the login keychain instead of aws-vault managing a hidden keychain
export AWS_VAULT_KEYCHAIN_NAME=login

# tweak session times so you don't have to re-enter passwords every 5min
export AWS_SESSION_TTL=24h
export AWS_ASSUME_ROLE_TTL=1h

# Helm switch from storing objects in kubernetes configmaps to
# secrets by default, but we still use the old default.
export HELM_DRIVER=configmap

# Go 1.16+ sets GO111MODULE to off by default with the intention to
# remove it in Go 1.18, which breaks projects using the dep tool.
# https://blog.golang.org/go116-module-changes
export GO111MODULE=auto
export GOPRIVATE=github.com/DataDog
export GOPROXY=binaries.ddbuild.io,https://proxy.golang.org,direct
export GONOSUMDB=github.com/DataDog,go.ddbuild.io

# Configure Go to pull go.ddbuild.io packages.
export GOPROXY="binaries.ddbuild.io,proxy.golang.org,direct"
export GONOSUMDB="github.com/DataDog,go.ddbuild.io"
# END ANSIBLE MANAGED BLOCK

# aliases
alias v="nvim"
alias k="kubectl"
alias ls="ls -lG --color=auto"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# prompt
#PS1='%F{blue}%~ %(?.%F{green}.%F{red})%#%f '
PS1='%F{blue}%~ %F{green}%#%f '
#PS1='%F{blue}[%2d] %(?.%F{green}.%F{red})%#%f '
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt histignoredups
setopt share_history
export GITLAB_TOKEN=$(security find-generic-password -a ${USER} -s gitlab_token -w)
export CI_JOB_TOKEN=$(security find-generic-password -a ${USER} -s gitlab_token -w)

# env variables for ddog access

# kubectl commands
function ke() {
    kubectl exec $1 -it -- bash
}
function kl() {
    kubectl logs -c busly $1 | rg snapshot | rg -v "not eligible"
}
function kg() {
    kubectl get pods
}
alias kcx='kubectx'
alias kns='kubens'
# staging:
function kes() {
    kubectl exec --context oddish-$1.us1.staging.dog $2 -it -- bash
}
function kls() {
    kubectl logs --context oddish-$1.us1.staging.dog -c busly $2 | rg snapshot | rg -v "not eligible"
}
function kgs() {
    kubectl get pods --context oddish-$1.us1.staging.dog
}
# shadow:
function kesh() {
    kubectl exec --context oddish-$1.us1.staging.dog $2 -it -- bash
}
function klsh() {
    kubectl logs --context oddish-$1.us1.staging.dog -c busly $2 | rg snapshot | rg -v "not eligible"
}
function kgsh() {
    kubectl get pods --context oddish-$1.us1.staging.dog
}

# Add kcf tool to path
export PATH="/Users/david.kwon/doge/experimental/teams/metrics-index:${PATH?}"

# alias docker-compose
alias dc='docker-compose'
export CXXFLAGS="-I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1"

eval "$(dd-gitsign load-key)"

# Created by `pipx` on 2025-09-15 15:03:32
export PATH="$PATH:/Users/david.kwon/.local/bin"

# BEGIN SCFW MANAGED BLOCK
alias npm="scfw run npm"
alias pip="scfw run pip"
alias poetry="scfw run poetry"
export SCFW_DD_AGENT_LOG_PORT="10365"
export SCFW_DD_LOG_LEVEL="ALLOW"
export SCFW_HOME="/Users/david.kwon/.scfw"
# END SCFW MANAGED BLOCK
