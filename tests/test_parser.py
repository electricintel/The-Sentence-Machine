"""Tests for the command parser."""

import os
import pytest
from sentence_machine.parser import parse


def test_parse_simple():
    assert parse("ls") == ("ls", [])


def test_parse_with_args():
    assert parse("ls -la /tmp") == ("ls", ["-la", "/tmp"])


def test_parse_quoted():
    assert parse('echo "hello world"') == ("echo", ["hello world"])


def test_parse_blank():
    assert parse("") == (None, [])
    assert parse("   ") == (None, [])


def test_parse_comment():
    assert parse("# this is a comment") == (None, [])


def test_parse_env_expansion(monkeypatch):
    monkeypatch.setenv("TESTVAR", "testvalue")
    cmd, args = parse("echo $TESTVAR")
    assert args == ["testvalue"]
