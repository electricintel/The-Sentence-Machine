# The Sentence Machine
Cross Platform Operating System (attempt)

## Overview

The Sentence Machine is a cross-platform command interpreter (shell) written in Python. It provides a read-eval-print loop (REPL) with built-in commands for navigating the filesystem, managing environment variables, and executing system programs.

## Requirements

- Python 3.9 or later

## Installation

```bash
pip install .
```

After installation, run the shell with:

```bash
sentence-machine
```

Or directly via Python:

```bash
python -m sentence_machine
```

## Built-in Commands

| Command | Description |
|---------|-------------|
| `cd [dir]` | Change directory (default: home) |
| `ls [dir]` | List directory contents |
| `pwd` | Print working directory |
| `echo [args...]` | Print text |
| `env` | Print environment variables |
| `export NAME=VALUE` | Set an environment variable |
| `unset NAME` | Remove an environment variable |
| `uname` | Print system information |
| `clear` | Clear the screen |
| `history` | Show command history |
| `help [command]` | Show available commands or help for a specific command |
| `exit [code]` | Exit the shell |
| `quit [code]` | Exit the shell (alias for exit) |

Any command not listed above is executed as a system program (e.g. `git status`, `python script.py`).

## Development

Run the tests:

```bash
pip install pytest
python -m pytest
```

