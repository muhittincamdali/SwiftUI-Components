# Contributing

Thanks for taking the time to improve SwiftUI Components.

## Reporting bugs

Open an issue with:

- the component and the initializer arguments you used,
- what you expected and what happened (a screenshot helps for visual bugs),
- platform and OS version (iOS simulator/device or macOS) and Xcode version.

## Pull requests

1. Fork the repository and branch from `main`.
2. Keep each pull request focused on one change.
3. Run the tests on both platforms:

    ```sh
    swift test
    xcodebuild test -scheme SwiftUIComponents \
      -destination 'platform=iOS Simulator,name=iPhone 17'
    ```

4. If you change logic (formatting, validation, layout maths, state managers), add or update a
   test in `Tests/SwiftUIComponentsTests`. Prefer moving that logic into a static function so it
   can be tested without rendering a view.
5. If you change a README code sample, change the copy in
   `Tests/SwiftUIComponentsTests/ReadmeExamples.swift` as well; that file is what gets compiled.
6. If a change affects the screenshots, regenerate them with `scripts/generate-screenshots.sh`.

## Code style

- Follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/).
- The package builds in the Swift 6 language mode; new code should not add warnings.
- Document public API with DocC comments (`///`).
- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)
  (`feat:`, `fix:`, `docs:`, `test:`, `refactor:`, `ci:`, `chore:`).

## License

By contributing you agree that your contributions are licensed under the MIT License.
