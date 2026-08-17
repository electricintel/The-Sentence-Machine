"""System command execution for The Sentence Machine."""

import subprocess
import shutil

# No timeout is imposed by default; callers that need one can wrap the shell.
_DEFAULT_TIMEOUT = None


def execute(command, args, shell):
    """Execute an external command and return the exit code."""
    executable = shutil.which(command)
    if executable is None:
        shell.error(f"{command}: command not found")
        return 127

    try:
        result = subprocess.run([executable] + args, shell=False, timeout=_DEFAULT_TIMEOUT)
        return result.returncode
    except PermissionError:
        shell.error(f"{command}: Permission denied")
        return 126
    except OSError as exc:
        shell.error(f"{command}: {exc}")
        return 1
