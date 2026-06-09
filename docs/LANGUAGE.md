# Nacre language notes

Nacre chooses **command mode** unless the line clearly looks like Perl. When a line enters Perl mode, it is executed by real Perl through `CORE::eval` in the interpreter running Nacre (`$^X`). Nacre does not implement a Perl clone.

## Command mode

```nacre
ls -lah
cat README.md | grep Nacre > hits.txt
false || echo recovered
sleep 30 &
```

Supported command conveniences include pipes, simple redirects, background jobs, aliases, abbreviations, environment assignments, globs, and `$VAR` expansion.

## Perl mode

Perl mode starts when a line begins with common Perl forms:

- `my`, `our`, `sub`, `use`, `package`, `BEGIN`, `END`, `for`, `foreach`, `if`, `while`, `unless`, `say`, `print`
- `$`, `@`, or `%`
- `=` for expression mode
- helper calls like `run(...)`, `capture(...)`, `cd(...)`
- `perl { ... }` or `p { ... }`

Examples:

```nacre
= 10 * 9
$name = "Nacre"
say lc $name
for my $f (files "*.txt") { say $f }
```

Variables assigned without `my` live in the persistent `Nacre::User` package because that is normal Perl package-variable behavior:

```nacre
$count = 5
say $count
```

`my` variables behave like normal Perl lexical variables and are local to that eval/block. Nacre does not fake lexical scope.

## Rc file

`~/.config/nacre/nacrerc.perl` is the canonical Perl source evaluated inside `Nacre::User`. Nacre also creates `~/.nacrerc.perl` as a synced home dotfile for quick editing.

```perl
option transient_prompt => 1;
option ghost_text => 1;
alias ll => 'ls -lah';
abbr g => 'git';
on preexec => sub { my ($line) = @_ };
```

Rc helpers are Perl functions, not shell builtins. That keeps the interactive command surface clean while making configuration powerful. Use `perl-runtime` or `perl_runtime()` to inspect the actual Perl engine.

## Pasted blocks

The interactive editor uses bracketed paste. Pasted multi-line blocks are inserted into the input buffer and wait for Enter before executing. When executed, Nacre evaluates complete Perl blocks as Perl and command-looking lines as command lines.

## Ghost suggestions

Ghost suggestions come from history, abbreviations, aliases, executable commands, and path globs. Right arrow or Ctrl-F accepts the suggestion. Colors adapt to truecolor, 256-color, 16-color, and `NO_COLOR` environments.

## Timing

Nacre has its own Bash-like `time` builtin:

```nacre
time -- cargo check
time -p -- perl -e 'select undef,undef,undef,0.1'
```

It prints `real`, `user`, and `sys` using Perl's wall clock and `times()` accounting.

## Compatibility

Use `compat` for shell syntax Nacre intentionally does not clone:

```nacre
compat 'for f in *.c; do echo "$f"; done'
```
