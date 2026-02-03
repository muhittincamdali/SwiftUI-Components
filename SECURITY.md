# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take the security of SwiftRouter seriously. If you have discovered a security vulnerability, we appreciate your help in disclosing it to us in a responsible manner.

### How to Report

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them via email to the repository owner. You can find contact information on the GitHub profile.

Please include the following information:

- Type of issue (e.g., deep link injection, state manipulation, etc.)
- Full paths of source file(s) related to the manifestation of the issue
- The location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit it

### What to Expect

- A confirmation of receipt within 48 hours
- An assessment of the vulnerability within 7 days
- Regular updates on our progress
- Credit for responsible disclosure (if desired)

## Security Best Practices

When using SwiftRouter in your projects:

1. **Validate Deep Links** - Always validate URL parameters before navigation
2. **Use Route Guards** - Implement authentication guards for protected routes
3. **Sanitize Parameters** - Never trust user input from URL parameters
4. **Audit Navigation Paths** - Review which screens are accessible via deep links

## Security Features

SwiftRouter includes several security considerations:

- **Type-Safe Parameters** - Reduces injection risks
- **Route Guards** - Authentication/authorization interceptors
- **URL Validation** - Built-in URL parsing with validation
- **No External Dependencies** - Minimal attack surface
