"""Core REPL for The Sentence Machine."""

import os
import sys
import platform

from .builtins import BUILTINS
from .executor import execute
from .parser import parse

HISTORY_LIMIT = 1000


class Shell:
    """Interactive command interpreter."""

    def __init__(self, prompt=None, history_file=None):
        self.history = []
        self.last_exit_code = 0
        self._prompt = prompt
        self._history_file = history_file or os.path.join(
            os.path.expanduser("~"), ".sentence_machine_history"
        )
        self._load_history()

    # ------------------------------------------------------------------
    # Public interface
    # ------------------------------------------------------------------

    def run(self):
        """Start the interactive read-eval-print loop."""
        print(f"The Sentence Machine {_version()} ({platform.system()})")
        print("Type 'help' for a list of commands, 'exit' to quit.\n")
        while True:
            try:
                line = input(self._get_prompt())
            except EOFError:
                print()
                break
            except KeyboardInterrupt:
                print()
                continue

            if not line.strip():
                continue

            self.execute_line(line)

    def execute_line(self, line, record_history=True):
        """Parse and execute a single input line."""
        if record_history and line.strip():
            self._add_history(line.strip())
        command, args = parse(line)
        if command is None:
            return 0
        return self._dispatch(command, args)

    def error(self, message):
        """Print an error message to stderr."""
        print(message, file=sys.stderr)

    # ------------------------------------------------------------------
    # Private helpers
    # ------------------------------------------------------------------

    def _dispatch(self, command, args):
        builtin = BUILTINS.get(command)
        if builtin is not None:
            try:
                builtin(args, self)
                self.last_exit_code = 0
            except SystemExit:
                raise
            except Exception as exc:  # noqa: BLE001
                self.error(f"{command}: {exc}")
                self.last_exit_code = 1
        else:
            self.last_exit_code = execute(command, args, self)
        return self.last_exit_code

    def _get_prompt(self):
        if self._prompt:
            return self._prompt
        cwd = os.getcwd()
        home = os.path.expanduser("~")
        if cwd.startswith(home):
            cwd = "~" + cwd[len(home):]
        return f"{cwd} $ "

    def _add_history(self, line):
        if self.history and self.history[-1] == line:
            return
        self.history.append(line)
        if len(self.history) > HISTORY_LIMIT:
            self.history = self.history[-HISTORY_LIMIT:]
        self._save_history()

    def _load_history(self):
        try:
            with open(self._history_file, encoding="utf-8") as fh:
                self.history = [entry.rstrip("\n") for entry in fh.readlines()]
        except OSError:
            self.history = []

    def _save_history(self):
        try:
            with open(self._history_file, "w", encoding="utf-8") as fh:
                fh.write("\n".join(self.history[-HISTORY_LIMIT:]) + "\n")
        except OSError:
            pass


def _version():
    from . import __version__
    return __version__
