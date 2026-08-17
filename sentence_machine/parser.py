"""Command-line parser for The Sentence Machine."""

import os
import shlex


def parse(line):
    """Parse a line of input into (command, args).

    Returns (None, []) for blank or comment lines.
    Expands environment variables in tokens.
    """
    line = line.strip()
    if not line or line.startswith("#"):
        return None, []

    try:
        tokens = shlex.split(line)
    except ValueError:
        # Unterminated quote — return the raw split as a best-effort
        tokens = line.split()

    if not tokens:
        return None, []

    tokens = [os.path.expandvars(os.path.expanduser(t)) for t in tokens]
    return tokens[0], tokens[1:]
