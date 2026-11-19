# PowerShell Developer Profile (`$PROFILE`)

A custom PowerShell configuration designed for **.NET developers**, **Git workflows**, **WSL users**, and Linux-style terminal productivity on Windows.

---

## Setup & Installation

1. **Allow local PowerShell scripts to run** (run once):
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
2. **Create your profile file** (if it doesn't exist yet):
   ```powershell
   New-Item -Path $PROFILE -Type File -Force
   ```
3. **Open and paste the configuration**:
   ```powershell
   notepad $PROFILE
   ```
4. **Reload your profile**:
   ```powershell
   . $PROFILE
   ```

> **Note for `ln` (Symbolic Links):** Creating symbolic links without Administrator rights requires **Developer Mode** enabled in Windows (`Settings` → `System` → `For developers`).

---

## Command Cheat Sheet

### 1. .NET CLI Shortcuts
| Alias | Command | Description |
| :--- | :--- | :--- |
| `dn` | `dotnet` | Base .NET CLI |
| `dnb` | `dotnet build` | Build the project/solution |
| `dnr` | `dotnet run` | Run the project |
| `dnw` | `dotnet watch run` | Run with hot-reload file watching |
| `dnt` | `dotnet test` | Execute unit/integration tests |
| `dnc` | `dotnet clean` | Clean build outputs |
| `dnrs` | `dotnet restore` | Restore NuGet packages |
| `dna <pkg>` | `dotnet add package <pkg>` | Install a NuGet package |
| `dns` | `dotnet sln` | Manage solution files |

### 2. Entity Framework Core Shortcuts
| Alias | Command | Description |
| :--- | :--- | :--- |
| `efa <Name>` | `dotnet ef migrations add <Name>` | Create a new EF Core migration |
| `efu` | `dotnet ef database update` | Apply pending migrations to the database |
| `efr` | `dotnet ef migrations remove` | Remove the last migration |
| `efd` | `dotnet ef database drop` | Drop the database |

### 3. Git Shortcuts
| Alias | Command | Description |
| :--- | :--- | :--- |
| `gs` | `git status -s` | Short working-tree status |
| `ga <file>` | `git add <file>` | Stage specific files |
| `gaa` | `git add .` | Stage all changes |
| `gc "<msg>"` | `git commit -m "<msg>"` | Commit staged changes with a message |
| `gp` | `git push` | Push commits to remote |
| `gpl` | `git pull` | Pull latest changes from remote |
| `gco <branch>` | `git checkout <branch>` | Switch branches or restore files |
| `gb` | `git branch` | List, create, or delete branches |
| `gl` | `git log --oneline -n 15` | Compact log of the last 15 commits |

### 4. Navigation, IDEs & Profile Helpers
| Alias | Action | Description |
| :--- | :--- | :--- |
| `..` | `Set-Location ..` | Move up one directory |
| `...` | `Set-Location ..\..` | Move up two directories |
| `la` | `Get-ChildItem -Force` | List all files, including hidden ones |
| `go2dev [proj]` | `cd D:\GitHubRepo\[proj]` | Jump to dev folder (supports **Tab** autocomplete) |
| `c` | `code .` | Open current directory in VS Code |
| `vs [target]` | `devenv.exe` | Open `.sln`/`.slnx` (auto-detected) or target in Visual Studio |
| `exp` | `explorer.exe .` | Open current directory in Windows File Explorer |
| `ep` | `notepad $PROFILE` | Edit this PowerShell profile |
| `rp` | `. $PROFILE` | Reload this PowerShell profile |

### 5. WSL Bridge
| Alias | Command | Description |
| :--- | :--- | :--- |
| `u` | `wsl -d Ubuntu` | Enter your Ubuntu WSL distribution |
| `lx <cmd>` | `wsl <cmd>` | Run a Linux command directly from PowerShell |

### 6. Linux-Style File & Text Utilities
| Alias | Usage | Description |
| :--- | :--- | :--- |
| `rmrf <path>` | `rmrf bin` | Force-delete files or folders recursively (`rm -rf`) |
| `ln <src> <dest>` | `ln .\a.json .\b.json` | Create a symbolic link (`ln -s`) |
| `touch <files...>` | `touch A.cs B.cs` | Create empty file(s) or update timestamps |
| `mkcd <dir>` | `mkcd NewApi` | Create a directory and `cd` into it |
| `grep <pattern>` | `dnb \| grep error` | Search text patterns in files or piped output |
| `which <cmd>` | `which dotnet` | Show the full path of an executable |
| `head <file> [n]` | `head app.log 20` | Show the first `n` lines of a file (default: 10) |
| `tail <file> [n]` | `tail app.log 20` | Live-watch the last `n` lines of a file (`tail -f`) |
| `export K=V` | `export ASPNETCORE_ENVIRONMENT=Development` | Set an environment variable for the current session |
| `env` | `env` | List all current environment variables |

### 7. Dev Cleanup & Network Helpers
| Alias | Usage | Description |
| :--- | :--- | :--- |
| `nuke` | `nuke` | Recursively delete all `bin` and `obj` folders in the current path |
| `killport <port>` | `killport 5000` | Terminate whatever process is occupying a local TCP port |
| `localip` | `localip` | Display your active local IPv4 address(es) |
| `pubip` | `pubip` | Fetch your public IP address |

### 8. Smart History Search (`PSReadLine`)
* **Up Arrow / Down Arrow:** Type the start of a command (e.g., `git` or `dn`) and press **Up/Down** to cycle exclusively through matching commands from your history.
