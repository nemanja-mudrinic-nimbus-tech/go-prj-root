# go-prj-root

A shell utility to navigate quickly between project roots and save your favorite project directories.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Open Source](https://img.shields.io/badge/Open%20Source-Yes-brightgreen)]()

*Developed by [Nemanja Mudrinic](https://github.com/nemanja-mudrinic-nimbus-tech) @ [Nimbus Tech](https://nimbus-tech.io)*

## Features

- Set and navigate to a session-specific project root directory
- Save global project roots by name for quick access from anywhere
- Works across different shells (Bash, Zsh, Fish)
- Special compatibility with Warp Terminal
- Easy to use with intuitive commands
- Lightweight with no external dependencies

## Installation

### Option 1: Automatic installation (Recommended)

```bash
git clone https://github.com/nemanja-mudrinic-nimbus-tech/go-prj-root
cd go-prj-root
chmod +x ./install.sh
./install.sh
```

The installer will:
- Place the script in `~/.local/bin/`
- Add appropriate lines to your shell configuration files
- For Warp Terminal, configure multiple initialization files for compatibility

### Option 2: Manual installation

1. Download the script:
```bash
mkdir -p ~/.local/bin
curl -o ~/.local/bin/go-prj-root https://raw.githubusercontent.com/nemanja-mudrinic-nimbus-tech/go-prj-root/main/go-prj-root.sh
chmod +x ~/.local/bin/go-prj-root
```

2. Add to your shell configuration files:

**Bash** (in `~/.bashrc` or `~/.bash_profile` on macOS):
```bash
source ~/.local/bin/go-prj-root
```

**Zsh** (in `~/.zshrc`):
```bash
source ~/.local/bin/go-prj-root
```

**Warp Terminal** (add to both files):
```bash
# In ~/.zshrc
source ~/.local/bin/go-prj-root

# In ~/.zprofile
source ~/.local/bin/go-prj-root
```

**Fish** (in `~/.config/fish/config.fish`):
```fish
source ~/.local/bin/go-prj-root
```

## Usage

### Session-specific project root

```bash
# Set current directory as the project root for this session
go-prj-root init

# Set a specific directory as the project root
go-prj-root init --path ~/projects/myapp

# Navigate to the project root
go-prj-root
```

### Global project roots

```bash
# Save current directory as a named project
go-prj-root save myproject

# Navigate to a saved project
go-prj-root goto myproject

# List all saved projects
go-prj-root list

# Remove a saved project
go-prj-root remove myproject
```

### Aliases

The following aliases are also available:

- `gpr`: Short for `go-prj-root`
- `gprg`: Short for `go-prj-root goto`
- `gprs`: Short for `go-prj-root save`
- `gprl`: Short for `go-prj-root list`

### Examples

```bash
# Working on a project
cd ~/Documents/projects/myapp
go-prj-root init

# Working deep in the project directory structure
cd src/components/auth/forms
# Go back to project root
go-prj-root

# Save a global project
cd ~/Documents/projects/myapp
go-prj-root save myapp

# From anywhere in the filesystem
go-prj-root goto myapp
# Or using the alias
gprg myapp
```

## Configuration

The script stores global project roots in:
```
~/.config/go-prj-root/projects.json
```

This file is automatically created if it doesn't exist.

## Troubleshooting

### Command not found after installation

If you get "command not found" in a new terminal after installation:

1. Try sourcing the script manually:
   ```bash
   source ~/.local/bin/go-prj-root
   ```

2. Make sure the script was added to the correct shell configuration file:
   ```bash
   grep -r "go-prj-root" ~/.zshrc ~/.zprofile ~/.profile
   ```

3. For Warp Terminal users, try adding the source line to both `.zshrc` and `.zprofile`:
   ```bash
   echo 'source ~/.local/bin/go-prj-root' >> ~/.zshrc
   echo 'source ~/.local/bin/go-prj-root' >> ~/.zprofile
   ```

### Other issues

- Restart your terminal or shell session after installation
- For Warp Terminal, you might need to restart the application

## FAQ

**Q: What's the difference between `init` and `save`?**  
A: `init` sets a project root for the current shell session only, while `save` stores it globally for all future sessions.

**Q: Does this work with terminal multiplexers like tmux?**  
A: Yes, each tmux pane/window maintains its own session project root.

**Q: Can I use this in scripts?**  
A: Yes, but be aware that the navigation commands are only available when the script is sourced.

**Q: Does this work with Warp terminal?**  
A: Yes, the installer automatically detects Warp and adds the script to multiple configuration files for compatibility.

**Q: Why do I need to source the script after installation?**  
A: Sourcing is only needed in terminals that were already open before installation. New terminal windows will have the command available automatically.

## About the Author

**Nemanja Mudrinic**
- GitHub: [Nemanja Mudrinic](https://github.com/nemanjamudrinski)
- LinkedIn: [Nemanja Mudrinic](https://github.com/nemanja-mudrinic-nimbus-tech)

This project is developed and maintained by [Nimbus Tech](https://nimbus-tech.io), a company specializing in cloud infrastructure, DevOps solutions and Product Development.

## Support the Project

If you find this tool useful, please consider:
- Starring the repository on GitHub
- Sharing it with your colleagues and friends
- Reporting any bugs or issues
- Contributing to the codebase

## License

MIT License

Copyright (c) 2023 Nemanja Mudrinic, Nimbus Tech

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
