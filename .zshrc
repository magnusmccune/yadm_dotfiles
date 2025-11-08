# --- Homebrew completion dirs first ---
HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"
fpath=("$HOMEBREW_PREFIX/share/zsh/functions" \
       "$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

export PATH="/opt/homebrew/bin:$PATH"

# --- zsh-autocomplete FIRST (per docs; do NOT call compinit yourself) ---
source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# --- Prompt/theme AFTER autocomplete ---
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config '/Users/mmccune/projects/personal/dotfiles/magnus.profile.omp.json')"
fi

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

#LS COLORS
export LS_COLORS="di=34;40:ln=36;40:so=35;40:pi=33;40:ex=32;40:bd=1;33;40:cd=1;33;40:su=0;41:sg=0;43:tw=0;42:ow=34;40:"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
export CLICOLOR=1

# ZSH History

HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=1000000
SAVEHIST=1000000
HIST_IGNORE_SPACE="true"

#
##
### All Completion stuff
##
#

# Make Tab drop into a persistent selection menu
zmodload zsh/complist
bindkey '^I' menu-select
bindkey "$terminfo[kcbt]" reverse-menu-complete  # Shift-Tab moves backwards

# Make suggestions show while you type (no Tab)
zstyle ':autocomplete:*' delay 0.08
zstyle ':autocomplete:*' min-input 1
# (These two are harmless on all versions; on newer builds they explicitly enable auto mode)
zstyle ':autocomplete:*' auto-insert yes
zstyle ':autocomplete:*' suggestions yes

source <(kubectl completion zsh)
source <(k3d completion zsh)
source <(helm completion zsh)

# Aliases
alias d=docker
alias h=helm
alias k=kubectl
alias tf=terraform
alias a=ansible
alias mp=multipass
alias localip="ipconfig getifaddr en0"
alias ll='ls -lG | sort -r'
alias lla='\ls -laG | sort -r'
alias k3d-up='k3d cluster create hivemq --servers 3 --agents 2 --kubeconfig-update-default --kubeconfig-switch-context'


#
##
### Kube Config Aliases
##
#

# Function to set K8s namespace to current directory name
set_k8s_namespace_to_dir() {
    # Get the name of the current directory
    local dir_name=$(basename "$PWD")

    # Set the Kubernetes namespace to the directory name
    kubectl config set-context --current --namespace="$dir_name"
    echo "Kubernetes namespace set to: $dir_name"
}
# Create an alias for the function
alias ksetnsdir='set_k8s_namespace_to_dir'

# Function to set the Kubernetes namespace
set_k8s_namespace_to_argument() {
  if [ -z "$1" ]; then
    echo "Usage: ksetns <namespace>"
    return 1
  fi

  # Set the namespace in the current context
  kubectl config set-context --current --namespace="$1"

  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "Namespace set to '$1' successfully."
  else
    echo "Failed to set namespace to '$1'."
    return 1
  fi
}

alias ksetns='set_k8s_namespace_to_argument'

# Function to unset the namespace of the current Kubernetes context
unset_k8s_namespace() {
    # Get the current context name
    local current_context=$(kubectl config current-context)

    # Unset the namespace for the current context
    kubectl config unset "contexts.$current_context.namespace"
}
# Create an alias for the function
alias kunsetns='unset_k8s_namespace'

alias kunset='kubectl config unset current-context'
alias kset-lab='kubectl config set current-context lab-cluster'
alias kset-mobile='kubectl config set current-context mobile-cluster'

#
##
###
##
#

epoch2iso() {
  ts=$(pbpaste)
  ts=${ts//[^0-9]/}
  if [[ ${#ts} -gt 10 ]]; then
    ts=$((ts / 1000))
  fi
  date -r "$ts" -u +"%Y-%m-%dT%H:%M:%SZ"
}

# Epoch Time to ISO8601

epoch2iso() {
    if [ -z "$1" ]; then
        echo "Usage: epoch2iso <epoch_seconds>"
        return 1
    fi
    # Convert from epoch to ISO8601 using UTC time
    date -r "$1" -u +"%Y-%m-%dT%H:%M:%SZ"
}

# Function to quickly get network details for active interfaces(equivalent to `ipconfig /all` on windows)

ipconfig_all() {
  # Gather a list of all interfaces that currently have an IP address
  local active_ifaces=()
  for IFACE in $(ifconfig -l); do
    # ipconfig getifaddr returns nonzero exit code if no IP is assigned
    if IP=$(ipconfig getifaddr "$IFACE" 2>/dev/null); then
      active_ifaces+=("$IFACE")
    fi
  done

  # If no interfaces found, bail out
  if [ ${#active_ifaces[@]} -eq 0 ]; then
    echo "No active network interfaces found."
    return
  fi

  # Print summary for each active interface
  for IFACE in "${active_ifaces[@]}"; do
    local IP=$(ipconfig getifaddr "$IFACE" 2>/dev/null)
    local SUBNET=$(ipconfig getoption "$IFACE" subnet_mask 2>/dev/null)
    # For the default gateway, we typically only have one "default" route, so
    # it won't necessarily differ across interfaces, but let's still show it for completeness.
    local GATEWAY=$(route -n get default 2>/dev/null | awk '/gateway:/{print $2}')

    echo "=== Network Summary for $IFACE ==="
    echo "IP Address:    ${IP:-N/A}"
    echo "Subnet Mask:   ${SUBNET:-N/A}"
    echo "Gateway:       ${GATEWAY:-N/A}"

    echo "DNS Servers:"
    # scutil --dns lumps all DNS info together, so you'll see them repeated.
    # But generally, these are the system-wide DNS servers in use.
    scutil --dns | awk '/nameserver\[[0-9]+\] :/{print "   " $3}'
    echo "==================================="
    echo
  done
}

MINICOM='-con'
export MINICOM

# AWS Profile Aliases
alias aws-hivemq-support='export AWS_DEFAULT_PROFILE=HiveMQ-Support'
alias aws-hivemq-test='export AWS_DEFAULT_PROFILE=HiveMQ-Test'
alias aws-hivemq-blue='export AWS_DEFAULT_PROFILE=HiveMQ-Blue'
alias aws-m3dev='export AWS_DEFAULT_PROFILE=M3Labs-4327'
alias aws-m3labs='export AWS_DEFAULT_PROFILE=M3Labs-3896'
alias aws-unset='unset AWS_DEFAULT_PROFILE'

# alias hivemq-up='docker run -p 8080:8080 -p 1883:1883 hivemq/hivemq4'

alias firewall-debug='sudo /usr/libexec/ApplicationFirewall/socketfilterfw -d'

# Python venvs - set local version with pyenv first `pyenv local 3.y`
function venv-create() {
    local dir_name=$(basename $(pwd))
    python3.11 -m venv --prompt "$dir_name" .venv
}
alias venv-activate='source .venv/bin/activate'

alias audio-reset='sudo killall -9 coreaudiod'


# --- prefer JDK 21 ---
export JAVA_HOME="$(/usr/libexec/java_home -v 21)"
export PATH="$JAVA_HOME/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/mmccune/.lmstudio/bin"export DISABLE_AUTOUPDATER=1


# >>> nvwb
# Sourcing the nvwb wrapper function was added during the NVIDIA AI Workbench installation and
# is required for NVIDIA AI Workbench to function properly. When uninstalling
# NVIDIA AI Workbench, it will be removed. 

source $HOME/.local/share/nvwb/nvwb-wrapper.sh
# >>> nvwb


. "$HOME/.local/bin/env"
