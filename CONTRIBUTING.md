# Contributing

Thank you for improving Nacre. This project values small, well-tested changes that keep the shell predictable for daily use.

## Development Setup

Requirements:

- Perl 5.16 or newer
- A Unix-like environment
- `sh`, `make`, and standard userland tools

Run the test suite:

```sh
make test
```

Install from a checkout:

```sh
make install
```

## Patch Guidelines

- Keep changes focused and easy to review.
- Prefer clear behavior over clever shell magic.
- Do not make Nacre pretend to be POSIX `sh` unless the project explicitly supports that syntax.
- Add or update smoke coverage for parser, runtime, installer, or rc behavior changes.
- Update `README.md`, `CHANGELOG.md`, `docs/LANGUAGE.md`, or `docs/nacre.1` when user-facing behavior changes.

## Commit Messages

Use concise imperative messages:

```text
fix smart cd for home directory
add installer man page support
document rc synchronization
```

## Pull Requests

Before opening a pull request:

```sh
make test
perl -c bin/nacre
```

Include a short summary, testing performed, and any compatibility notes.
