#!/usr/bin/env bash
# go-prj-root: Navigate to project roots quickly
# Version: 1.0.0

PRJ_ROOT_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/go-prj-root-data"
PRJ_ROOT_PROJECTS_FILE="$PRJ_ROOT_CONFIG_DIR/projects.json"

mkdir -p "$PRJ_ROOT_CONFIG_DIR"
touch "$PRJ_ROOT_PROJECTS_FILE" 2>/dev/null || true

function show_help() {
  echo "Usage: go-prj-root [COMMAND] [OPTIONS]"
  echo
  echo "Commands:"
  echo "  (none)             Navigate to current session's project root"
  echo "  init [--path PATH] Set current session's project root"
  echo "  save NAME          Save current directory as a global project root with NAME"
  echo "  goto NAME          Navigate to a saved global project root"
  echo "  list               List all saved global project roots"
  echo "  remove NAME        Remove a saved global project root"
  echo "  help               Display this help message"
  echo
  echo "Options:"
  echo "  --path PATH        Specify a path (for 'init' command)"
  echo
  echo "Examples:"
  echo "  go-prj-root init                          # Set current directory as session root"
  echo "  go-prj-root init --path ~/projects/app    # Set specific path as session root"
  echo "  go-prj-root                               # Go to session root"
  echo "  go-prj-root save myproject                # Save current dir as 'myproject'"
  echo "  go-prj-root goto myproject                # Go to saved 'myproject' directory"
  echo "  go-prj-root list                          # List all saved projects"
  echo "  go-prj-root remove myproject              # Remove 'myproject' from saved list"
}

function json_get_value() {
  local file="$1"
  local key="$2"
  grep -o "\"$key\":[^,}]*" "$file" 2>/dev/null | sed 's/.*:"\(.*\)".*/\1/' | sed 's/.*:\([^"]*\).*/\1/'
}

function json_write() {
  local file="$1"
  local name="$2"
  local path="$3"
  
  if [ ! -s "$file" ]; then
    echo "{\"$name\":\"$path\"}" > "$file"
    return
  fi
  
  local content=$(cat "$file")
  content=${content%\}}
  if [ "$content" != "{" ]; then
    content="$content,"
  fi
  echo "$content\"$name\":\"$path\"}" > "$file"
}

function json_remove() {
  local file="$1"
  local name="$2"
  
  if [ ! -s "$file" ]; then
    return
  fi
  
  local content=$(cat "$file")
  content=$(echo "$content" | sed "s/\"$name\":\"[^\"]*\",//g" | sed "s/,\"$name\":\"[^\"]*\"//g" | sed "s/\"$name\":\"[^\"]*\"//g")
  if [ "$content" == "{}" ] || [ "$content" == "{" ] || [ "$content" == "}" ]; then
    echo "{}" > "$file"
  else
    echo "$content" > "$file"
  fi
}

function json_list() {
  local file="$1"
  
  if [ ! -s "$file" ]; then
    echo "No saved project roots."
    return
  fi
  
  local content=$(cat "$file")
  content=${content#\{}
  content=${content%\}}
  
  if [ -z "$content" ]; then
    echo "No saved project roots."
    return
  fi
  
  echo "Saved project roots:"
  echo
  
  IFS=',' read -ra ENTRIES <<< "$content"
  for entry in "${ENTRIES[@]}"; do
    key=$(echo "$entry" | sed 's/"\([^"]*\)":.*/\1/')
    value=$(echo "$entry" | sed 's/.*:"\([^"]*\)".*/\1/')
    printf "  %-20s %s\n" "$key" "$value"
  done
}

function go_to_project_root() {
  local command="$1"
  shift
  
  case "$command" in
    init)
      local path=$(pwd)
      if [[ "$1" == --path=* ]]; then
        path="${1#--path=}"
        shift
      elif [[ "$1" == --path ]]; then
        shift
        path="$1"
        shift
      fi
      
      path=$(eval echo "$path")
      if [ ! -d "$path" ]; then
        echo "Error: Directory does not exist: $path"
        return 1
      fi
      
      PRJ_ROOT_DIR=$(cd "$path" && pwd)
      echo "Session project root set to: $PRJ_ROOT_DIR"
      ;;
      
    save)
      local name="$1"
      if [ -z "$name" ]; then
        echo "Error: Project name required. Usage: go-prj-root save NAME"
        return 1
      fi
      
      local path=$(pwd)
      json_write "$PRJ_ROOT_PROJECTS_FILE" "$name" "$path"
      echo "Saved global project root '$name': $path"
      ;;
      
    goto)
      local name="$1"
      if [ -z "$name" ]; then
        echo "Error: Project name required. Usage: go-prj-root goto NAME"
        return 1
      fi
      
      local path=$(json_get_value "$PRJ_ROOT_PROJECTS_FILE" "$name")
      if [ -z "$path" ]; then
        echo "Error: Project '$name' not found. Use 'go-prj-root list' to see available projects."
        return 1
      fi
      
      if [ ! -d "$path" ]; then
        echo "Error: Project directory no longer exists: $path"
        return 1
      fi
      
      cd "$path" || return 1
      echo "Changed to project directory: $path"
      ;;
      
    list)
      json_list "$PRJ_ROOT_PROJECTS_FILE"
      ;;
      
    remove)
      local name="$1"
      if [ -z "$name" ]; then
        echo "Error: Project name required. Usage: go-prj-root remove NAME"
        return 1
      fi
      
      json_remove "$PRJ_ROOT_PROJECTS_FILE" "$name"
      echo "Removed project '$name' from global list."
      ;;
      
    help)
      show_help
      ;;
      
    "")
      if [ -z "$PRJ_ROOT_DIR" ]; then
        echo "Error: Session project root not set. Use 'go-prj-root init' first."
        return 1
      fi
      
      if [ ! -d "$PRJ_ROOT_DIR" ]; then
        echo "Error: Session project root no longer exists: $PRJ_ROOT_DIR"
        return 1
      fi
      
      cd "$PRJ_ROOT_DIR" || return 1
      echo "Changed to session project root: $PRJ_ROOT_DIR"
      ;;
      
    *)
      echo "Error: Unknown command '$command'"
      show_help
      return 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  go_prj_root() {
    go_to_project_root "$@"
  }
  alias go-prj-root='go_prj_root'
  alias gpr='go_prj_root'
  alias gprg='go_prj_root goto'
  alias gprs='go_prj_root save'
  alias gprl='go_prj_root list'
else
  go_to_project_root "$@"
fi
