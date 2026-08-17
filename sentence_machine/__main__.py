"""Entry point for `python -m sentence_machine`."""

from .shell import Shell


def main():
    shell = Shell()
    shell.run()


if __name__ == "__main__":
    main()
