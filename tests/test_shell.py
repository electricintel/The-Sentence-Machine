"""Tests for built-in commands."""

import os
import sys
import pytest
from sentence_machine.shell import Shell


@pytest.fixture
def shell(tmp_path):
    return Shell(history_file=str(tmp_path / ".history"))


def test_echo(capsys, shell):
    shell.execute_line("echo hello world")
    assert capsys.readouterr().out.strip() == "hello world"


def test_pwd(capsys, shell):
    shell.execute_line("pwd")
    assert capsys.readouterr().out.strip() == os.getcwd()


def test_cd(tmp_path, shell):
    shell.execute_line(f"cd {tmp_path}")
    assert os.getcwd() == str(tmp_path)
    os.chdir(os.path.dirname(__file__))  # restore


def test_cd_invalid(capsys, shell):
    shell.execute_line("cd /this/path/does/not/exist/hopefully")
    err = capsys.readouterr().err
    assert "No such file or directory" in err


def test_ls(tmp_path, capsys, shell):
    (tmp_path / "file.txt").write_text("data")
    shell.execute_line(f"ls {tmp_path}")
    out = capsys.readouterr().out
    assert "file.txt" in out


def test_env_set_and_unset(shell):
    shell.execute_line("export MY_SHELL_VAR=hello")
    assert os.environ.get("MY_SHELL_VAR") == "hello"
    shell.execute_line("unset MY_SHELL_VAR")
    assert "MY_SHELL_VAR" not in os.environ


def test_history(capsys, shell):
    shell.execute_line("echo first")
    shell.execute_line("echo second")
    shell.execute_line("history")
    out = capsys.readouterr().out
    assert "echo first" in out
    assert "echo second" in out


def test_help(capsys, shell):
    shell.execute_line("help")
    out = capsys.readouterr().out
    assert "echo" in out
    assert "cd" in out


def test_exit_raises(shell):
    with pytest.raises(SystemExit) as exc_info:
        shell.execute_line("exit 42")
    assert exc_info.value.code == 42


def test_unknown_command(capsys, shell):
    code = shell.execute_line("__nonexistent_cmd__")
    err = capsys.readouterr().err
    assert "command not found" in err
    assert code == 127


def test_blank_line(shell):
    code = shell.execute_line("")
    assert code == 0
