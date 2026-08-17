"""Built-in commands for The Sentence Machine."""

import os
import sys
import platform

BUILTINS = {}


def register(name):
    """Decorator to register a built-in command."""
    def decorator(fn):
        BUILTINS[name] = fn
        return fn
    return decorator


@register("cd")
def cmd_cd(args, shell):
    """Change the current working directory."""
    path = args[0] if args else os.path.expanduser("~")
    try:
        os.chdir(path)
    except FileNotFoundError:
        shell.error(f"cd: {path}: No such file or directory")
    except NotADirectoryError:
        shell.error(f"cd: {path}: Not a directory")
    except PermissionError:
        shell.error(f"cd: {path}: Permission denied")


@register("pwd")
def cmd_pwd(args, shell):
    """Print the current working directory."""
    print(os.getcwd())


@register("ls")
def cmd_ls(args, shell):
    """List directory contents."""
    path = args[0] if args else "."
    try:
        entries = sorted(os.listdir(path))
        for entry in entries:
            full = os.path.join(path, entry)
            suffix = "/" if os.path.isdir(full) else ""
            print(entry + suffix)
    except FileNotFoundError:
        shell.error(f"ls: {path}: No such file or directory")
    except PermissionError:
        shell.error(f"ls: {path}: Permission denied")


@register("echo")
def cmd_echo(args, shell):
    """Print arguments to stdout."""
    print(" ".join(args))


@register("env")
def cmd_env(args, shell):
    """Print environment variables."""
    for key, value in sorted(os.environ.items()):
        print(f"{key}={value}")


@register("export")
def cmd_export(args, shell):
    """Set an environment variable (NAME=VALUE)."""
    for arg in args:
        if "=" in arg:
            key, _, value = arg.partition("=")
            os.environ[key] = value
        else:
            shell.error(f"export: invalid argument: {arg}")


@register("unset")
def cmd_unset(args, shell):
    """Unset an environment variable."""
    for arg in args:
        os.environ.pop(arg, None)


@register("uname")
def cmd_uname(args, shell):
    """Print system information."""
    print(platform.system(), platform.release(), platform.machine())


@register("clear")
def cmd_clear(args, shell):
    """Clear the terminal screen."""
    os.system("cls" if platform.system() == "Windows" else "clear")


@register("history")
def cmd_history(args, shell):
    """Show command history."""
    for i, entry in enumerate(shell.history, start=1):
        print(f"{i:4}  {entry}")


@register("help")
def cmd_help(args, shell):
    """Show available commands."""
    if args:
        name = args[0]
        fn = BUILTINS.get(name)
        if fn:
            doc = fn.__doc__ or "No description available."
            print(f"{name}: {doc}")
        else:
            shell.error(f"help: unknown command: {name}")
    else:
        print("Built-in commands:")
        for name, fn in sorted(BUILTINS.items()):
            doc = fn.__doc__ or ""
            print(f"  {name:<12} {doc}")
        print("\nAny other input is executed as a system command.")


@register("exit")
def cmd_exit(args, shell):
    """Exit the shell."""
    code = 0
    if args:
        try:
            code = int(args[0])
        except ValueError:
            shell.error(f"exit: {args[0]!r}: numeric argument required")
            return
    sys.exit(code)


@register("quit")
def cmd_quit(args, shell):
    """Exit the shell."""
    cmd_exit(args, shell)
