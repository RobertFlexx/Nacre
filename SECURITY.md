# Security Policy

## Supported Versions

Security fixes are accepted for the current public release series.

| Version | Supported |
| --- | --- |
| 0.4.x | Yes |
| Earlier private releases | No |

## Reporting a Vulnerability

Do not open a public issue for a suspected vulnerability.

Send a private report to the maintainer with:

- A description of the issue
- Steps to reproduce
- Affected versions or commits
- Expected impact
- Any suggested fix or mitigation

If the repository has GitHub private vulnerability reporting enabled, use that channel. Otherwise, contact the maintainer directly through the email address listed on the project profile or package metadata.

## Scope

Security-sensitive areas include command execution, quoting, rc loading, file writes, environment handling, and update/install scripts.

Nacre is not a sandbox. Perl mode intentionally executes user-provided Perl code with the user's privileges.
