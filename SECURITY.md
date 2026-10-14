# Security Policy

## Supported versions

Only the latest commit on `main` receives fixes.

## Reporting a vulnerability

Please do not open a public issue for security problems. Use GitHub's
[private vulnerability reporting](https://github.com/muhittincamdali/SwiftUI-Components/security/advisories/new)
or email muhittincamdali@gmail.com with a description, the affected component and steps to
reproduce.

## Scope

This package contains UI components only. It does not make network requests or store data.
`CreditCardInput` and the PIN/OTP fields format and validate what the user types but do not
transmit, persist or log it; protecting that data in your app (for example, not logging the
bound strings) remains your responsibility.
