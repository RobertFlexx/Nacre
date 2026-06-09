# Changelog

Nacre `0.4.2` is the first public release series. All versions below `0.4.2` were private, nonpublic testing releases used to stabilize the shell before public distribution. This is why the first public version number is higher than `0.1.0`.

## 0.4.2

- Fixed bare `~` and single directory words being misclassified as executable commands.
- Added friendlier syntax errors for bare/leading/trailing pipeline operators.
- Added friendlier syntax error for a lone backslash.
- Prevented directories from being executed like programs; users get a `use cd` style message.
- Made prompt and `pwd` prefer logical `PWD`, which keeps smart-cd behavior nicer around symlinks.
- Added regression tests for `~`, `/tmp`, `|`, and `\`.

## 0.4.1

- Fixed pasted/multiline Perl execution so consecutive Perl lines are grouped and evaluated as one real Perl unit.
- Added regression coverage for `package TestThing; sub hi { ... }; package Nacre::User; say TestThing::hi();`.
- Prevented package declarations from being separated from later sub definitions by shell-side routing.

## 0.4.0

- Made the real Perl runtime path explicit: Perl mode and rc files use `CORE::eval` in the actual Perl interpreter running Nacre.
- Added `perl-runtime` builtin showing `$^X`, `$^V`, architecture, privlib, package, and strict mode.
- Added `perl_runtime()` and `real_perl()` helpers in `Nacre::User`.
- Added routing for `package`, `BEGIN`, `END`, `CHECK`, `INIT`, and `UNITCHECK` forms so they go to Perl mode.
- Added tests proving `$^X`, `package`, `sub`, and runtime reflection work through real Perl.

## 0.3.3

- Fixed pasted/typed bare Perl blocks beginning with `{` being treated as external commands.
- Fixed block collection so `my` variables inside `{ ... }` execute in the same Perl eval unit.
- Added smoke coverage for multiline Perl blocks returning `84`.

## 0.3.2

- Added synced home dotfile rc path: `~/.nacrerc.perl`.
- First run now creates both `~/.config/nacre/nacrerc.perl` and `~/.nacrerc.perl`.
- Existing rc pairs are synchronized by newer mtime unless they are already the same file.
- Added `dotrc()` rc/runtime helper and updated `help rc` / `set` output.

## 0.3.1

- Renamed the default rc path to `~/.config/nacre/nacrerc.perl`.
- Added legacy fallback for existing `~/.config/nacre/nacre.rc` files.
- Updated generated config, docs, examples, and tests to use `nacrerc.perl`.

## 0.3.0

- Added Perl-first rc file configuration.
- Added rc helpers: `option`, `alias`, `abbr`, `mark`, `env`, `on`, `transient`, `ghost`, `rcfile`.
- Added transient prompt support.
- Added predictive ghost text with terminal-aware color fallbacks.
- Added Right/Ctrl-F ghost acceptance.
- Added abbreviation expansion during typing and execution.
- Added `precmd`, `preexec`, and `chpwd` hooks.
- Added terminal title updates for cwd/current command.
- Added compact prompt and one-line prompt options.
- Updated docs and examples for Perl rc syntax.

## 0.2.1

- Fixed invisible typing on some terminals.
- Improved prompt width math and redraw behavior.
- Hardened Ctrl-C and missing-command handling.

## 0.2.0

- Added custom cbreak line editor.
- Added bracketed paste support.
- Added syntax highlighting and Bash-like `time`.

## 0.1.0

- Initial Perl-native shell prototype.
