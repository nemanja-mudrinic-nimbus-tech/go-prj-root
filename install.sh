#!/usr/bin/env bash
# Installer for go-prj-root
# Version: 1.0.0

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${HOME}/.local/bin"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/go-prj-root-data"
SCRIPT_PATH="${INSTALL_DIR}/go-prj-root"
SHELL_PROFILE=""

detect_shell_profile() {
  echo "Detecting shell profile..."
  echo "ZSH_VERSION: $ZSH_VERSION"
  echo "TERM_PROGRAM: $TERM_PROGRAM"
  echo "WARP_IS_LOCAL_SHELL: $WARP_IS_LOCAL_SHELL"
  echo "SHELL: $SHELL"
  
  if [[ -n "$ZSH_VERSION" ]] || [[ "$SHELL" == *"zsh"* ]]; then
    echo "Detected Zsh shell"
    if [[ "$TERM_PROGRAM" == "WarpTerminal" ]]; then
      echo "Detected Warp Terminal"
      SHELL_PROFILE="$HOME/.zshrc"
    else
      echo "Using standard Zsh setup"
      SHELL_PROFILE="${ZDOTDIR:-$HOME}/.zshrc"
    fi
  elif [[ -n "$BASH_VERSION" ]] || [[ "$SHELL" == *"bash"* ]]; then
    echo "Detected Bash shell"
    if [[ "$OSTYPE" == "darwin"* ]]; then
      SHELL_PROFILE="$HOME/.bash_profile"
      [[ ! -f "$SHELL_PROFILE" ]] && SHELL_PROFILE="$HOME/.profile"
    else
      SHELL_PROFILE="$HOME/.bashrc"
    fi
  elif [[ "$SHELL" == *"fish"* ]]; then
    echo "Detected Fish shell"
    SHELL_PROFILE="$HOME/.config/fish/config.fish"
  else
    echo "Using default profile"
    SHELL_PROFILE="$HOME/.profile"
  fi
  
  echo "Selected shell profile: $SHELL_PROFILE"
}

create_directories() {
  mkdir -p "$INSTALL_DIR"
  mkdir -p "$CONFIG_DIR"
}

install_script() {
  cp "${SCRIPT_DIR}/go-prj-root.sh" "$SCRIPT_PATH"
  chmod +x "$SCRIPT_PATH"
  
  touch "${CONFIG_DIR}/projects.json" 2>/dev/null || true
  if [[ ! -s "${CONFIG_DIR}/projects.json" ]]; then
    echo "{}" > "${CONFIG_DIR}/projects.json"
  fi
  
  echo "Installed go-prj-root to $SCRIPT_PATH"
}

update_shell_profile() {
  local SOURCE_LINE="source $SCRIPT_PATH"
  
  echo "Updating shell profiles for maximum compatibility..."
  
  if [[ "$TERM_PROGRAM" == "WarpTerminal" ]]; then
    echo "Adding to multiple shell config files for Warp Terminal..."
    
    local config_files=("$HOME/.zshrc" "$HOME/.zprofile" "$HOME/.zlogin" "$HOME/.profile")
    
    for config_file in "${config_files[@]}"; do
      if [[ ! -f "$config_file" ]]; then
        echo "Creating $config_file"
        touch "$config_file"
      fi
      
      if grep -q "source.*go-prj-root" "$config_file" 2>/dev/null; then
        echo "$config_file already contains go-prj-root sourcing"
      else
        echo -e "\n# Initialize go-prj-root\n$SOURCE_LINE" >> "$config_file"
        echo "Added sourcing to $config_file"
      fi
    done
  else
    if grep -q "source.*go-prj-root" "$SHELL_PROFILE" 2>/dev/null; then
      echo "$SHELL_PROFILE already contains go-prj-root sourcing"
    else
      echo -e "\n# Initialize go-prj-root\n$SOURCE_LINE" >> "$SHELL_PROFILE"
      echo "Added sourcing to $SHELL_PROFILE"
    fi
  fi
}

show_completion() {
  echo
  echo "Installation complete!"
  echo
  echo "To start using go-prj-root now, run:"
  echo "  source $SCRIPT_PATH"
  echo
  echo "Available commands:"
  echo "  go-prj-root init                # Set current directory as project root"
  echo "  go-prj-root                     # Navigate to project root"
  echo "  go-prj-root save myproject      # Save current dir globally as 'myproject'"
  echo "  go-prj-root goto myproject      # Go to saved 'myproject'"
  echo "  go-prj-root list                # List all saved projects"
  echo
  echo "Aliases:"
  echo "  gpr                             # Short for go-prj-root"
  echo "  gprg myproject                  # Short for go-prj-root goto myproject"
  echo "  gprs myproject                  # Short for go-prj-root save myproject"
  echo
  echo "Run 'go-prj-root help' for more information."
}

main() {
  echo "Installing go-prj-root..."
  detect_shell_profile
  create_directories
  install_script
  update_shell_profile
  show_completion
}

main "$@"
