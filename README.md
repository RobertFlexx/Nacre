# Nacre

> A Perl-native interactive shell for daily development work.

[![Version](https://img.shields.io/badge/version-0.4.2-blue.svg)](CHANGELOG.md)
[![Language](https://img.shields.io/badge/language-Perl-39457e.svg)](bin/nacre)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Linux](https://img.shields.io/badge/Linux-supported-brightgreen.svg)](#platform-support)
[![macOS](https://img.shields.io/badge/macOS-supported-brightgreen.svg)](#platform-support)
[![BSD](https://img.shields.io/badge/BSD-best_effort-yellow.svg)](#platform-support)

Nacre is an interactive shell where normal Unix commands stay normal, while scripting, configuration, and runtime customization use real Perl. It provides pipes, redirects, jobs, aliases, marks, project helpers, a cbreak editor, ghost suggestions, and a Perl rc file that behaves like an actual runtime instead of a shell-specific mini-language.

```nacre
ls -lah | grep .pl
for my $f (files "*.pl") { run("perl", "-c", $f) }
if (-e "Cargo.toml") { run("cargo check") }
```

## Status

Nacre is usable as an interactive development shell. It is not POSIX `sh`, and it should not be installed as `/bin/sh` or used for boot-critical scripts.

Version `0.4.2` is the first public release series. Earlier versions were private, nonpublic testing releases, which is why the project starts public distribution at a higher version number.

## Platform Support

| Platform | Support level | Notes |
| --- | --- | --- |
| Linux | Supported | Primary development target. |
| macOS | Supported | Requires system Perl or a newer Perl from Homebrew/MacPorts. |
| FreeBSD, OpenBSD, NetBSD | Best effort | Expected to work with Perl 5.16+ and common userland tools. |
| WSL | Supported | Use a Linux distribution inside WSL. |
| Native Windows | Not supported | Use WSL for Windows systems. |

## Requirements

- Perl 5.16 or newer
- A Unix-like operating system
- Standard userland tools such as `sh`, `cp`, `mkdir`, and `chmod`
- `curl` only for one-line remote installation

Check Perl:

```sh
perl -v
```

## Install

Install from a checked-out release:

```sh
./install.sh
```

Install to a custom prefix:

```sh
PREFIX="$HOME/.local" ./install.sh
```

Install with `curl`:

```sh
curl -fsSL https://raw.githubusercontent.com/RobertFlexx/Nacre/main/install.sh | sh
```

The installer copies:

```text
~/.local/bin/nacre
~/.local/bin/nacre-update
~/.local/share/man/man1/nacre.1
```

Make sure `~/.local/bin` is on your `PATH`:

```sh
export PATH="$HOME/.local/bin:$PATH"
```

Run Nacre:

```sh
nacre
```

Run one command:

```sh
nacre -c 'doctor .'
nacre -c 'for my $f (files "*.pl") { run("perl", "-c", $f) }'
```

## Update

From a checked-out release:

```sh
./update.sh
```

From an installed copy:

```sh
nacre-update
```

Remote update with `curl`:

```sh
curl -fsSL https://raw.githubusercontent.com/RobertFlexx/Nacre/main/update.sh | sh
```

## Quick Start

Command mode runs normal programs:

```nacre
ls -lah
cat README.md | grep Nacre
echo hello > out.txt
sleep 30 &
jobs
```

Perl mode runs real Perl through `CORE::eval` in the Perl interpreter running Nacre:

```nacre
$x = 40
say $x + 2
for my $f (files "*.rs") { say $f }
if (-e "Cargo.toml") { run("cargo run") }
```

Expression mode starts with `=`:

```nacre
= 2 + 2
= join ", ", files("*.pl")
```

Check the runtime:

```nacre
perl-runtime
= perl_runtime()->{executable}
```

## Configuration

First run creates:

```text
~/.config/nacre/nacrerc.perl
~/.nacrerc.perl
```

The rc file is real Perl evaluated inside `Nacre::User`:

```perl
option transient_prompt => 1;
option ghost_text       => 1;
option ghost_color      => 'auto';
option prompt_style     => 'power';
option prompt_newline   => 1;
option auto_title       => 1;

alias ll => 'ls -lah';
alias gs => 'git status --short --branch';
abbr  g  => 'git';
abbr  c  => 'cargo';

env EDITOR => 'nano';
mark src => "$ENV{HOME}/src";

on preexec => sub {
    my ($line) = @_;
};

on chpwd => sub {
    my ($dir) = @_;
};
```

Reload config:

```nacre
reload
```

Show config paths:

```nacre
help rc
set
```

## Interactive Features

Ghost suggestions use history, aliases, abbreviations, commands, and paths.

```text
Right Arrow    accept ghost suggestion
Ctrl-F         accept ghost suggestion
Tab            show or complete candidates
```

The editor supports common shell key bindings:

```text
Enter       run current line or block
Ctrl-C      cancel input or interrupt foreground command
Ctrl-D      exit on empty input
Ctrl-L      clear and redraw
Ctrl-A/E    move to start or end of line
Ctrl-U/K    delete before or after cursor
Ctrl-W      delete previous word
Arrows      history and cursor movement
Home/End    move to start or end
Delete      delete under cursor
Paste       bracketed paste waits for Enter
```

## Builtins

Navigation:

```nacre
cd DIR
pwd
pushd DIR
popd
dirs
up 2
take new/project
```

Typing a directory name by itself also changes into it:

```nacre
src
..
...
```

Marks:

```nacre
mark proj ~/projects/my-game
go proj
marks
unmark proj
```

Aliases:

```nacre
alias ll="ls -lah"
alias gs="git status --short"
aliases
unalias ll
```

Environment and path:

```nacre
export EDITOR=nano
unset DEBUG
env
path show
path add ~/.local/bin
path rm /some/bad/path
```

System helpers:

```nacre
sysinfo
doctor .
which cargo
type cd
history 50
highlight script.nacre
transcript path
clear
clear -x
```

Timing:

```nacre
time -- cargo build --release
time -p -- perl -e 'select undef,undef,undef,0.25'
time -- ls -lah | wc -l
```

## Perl Helpers

Inside Perl mode and rc files, these helpers are available:

```perl
run("ls -lah")
run("wc", "-l", "file")
sh("echo $SHELL")
capture("git status --short")
cd("src")
pwd()
files("*.pl")
slurp("README.md")
spew("out.txt", "hello\n")
append("log.txt", "entry\n")
which("perl")
env("EDITOR", "nano")
edit("README.md")
option transient_prompt => 1
alias ll => "ls -lah"
abbr g => "git"
on preexec => sub { my ($line) = @_ }
```

## Compatibility

Nacre intentionally does not clone every Bash or POSIX shell feature. Use `compat` when exact shell syntax is required:

```nacre
compat 'for f in *.c; do echo "$f"; done'
```

Normal Nacre commands do not go through Bash by default.

## Documentation

- [Changelog](CHANGELOG.md)
- [Language notes](docs/LANGUAGE.md)
- `man nacre` after installation
- `mandoc -Tutf8 docs/nacre.1` from the repository

## Development

Run smoke tests:

```sh
./tests/smoke.sh
```

Or use `make`:

```sh
make test
make install
make update
```

## Project Policies

- [Contributing](CONTRIBUTING.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Security](SECURITY.md)
- [License](LICENSE)
