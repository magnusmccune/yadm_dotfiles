
# Set Homebrew path based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  HOMEBREW_PREFIX="/opt/homebrew"
else
  HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

if [[ -f "$HOMEBREW_PREFIX/bin/brew" ]]; then
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi
