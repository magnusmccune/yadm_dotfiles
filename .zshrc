if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
#    eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/magnusmccune/dotfiles/main/magnus.profile.omp.json')"
    eval "$(oh-my-posh init zsh --config '/Users/mmccune/projects/personal/dotfiles/magnus.profile.omp.json')"
fi
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

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

# Autocomplete for awscli
#autoload bashcompinit && bashcompinit
#autoload -Uz compinit && compinit
complete -C '/opt/homebrew/bin/aws_completer' aws

source <(kubectl completion zsh)
source <(k3d completion zsh)
source <(helm completion zsh)
source <(k3sup completion zsh)
#source /opt/homebrew/etc/bash_completion.d/az                 
#compdef _k3d k3d

# Aliases
alias d=docker
alias h=helm
alias k=kubectl
alias tf=terraform
alias a=ansible
alias mp=multipass
alias localip="ipconfig getifaddr en0"
alias ll='ls -lG | sort -r'
alias lla='\ls -laG | sort -r'\
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
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/mc mc


complete -o nospace -C /opt/homebrew/bin/terraform terraform
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/mmccune/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions


# --- prefer JDK 17 ---
export JAVA_HOME="$(/usr/libexec/java_home -v 17)"
export PATH="$JAVA_HOME/bin:$PATH"
# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/mmccune/.lmstudio/bin"