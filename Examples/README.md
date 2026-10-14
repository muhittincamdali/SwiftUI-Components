# Examples

## ComponentGallery

A small iOS and macOS app with one screen per README sample: the quick start, buttons, charts,
the payment form, snackbars, the flow layout, a validated sign-up form, a form built from
JSON and the gestures. It uses the package from this checkout (a
local package reference to `../..`), so it always shows the current code.

Run it:

1. Open `Examples/ComponentGallery/ComponentGallery.xcodeproj` in Xcode 26 or later.
2. Choose the **ComponentGallery** scheme and an iPhone simulator or **My Mac** as the run
   destination.
3. Press **Run** (⌘R).

From the command line:

```sh
cd Examples/ComponentGallery
xcodebuild build -scheme ComponentGallery -destination 'generic/platform=iOS Simulator'
xcodebuild build -scheme ComponentGallery -destination 'platform=macOS'
```

The samples live in
[`ComponentGallery/ReadmeSamples.swift`](ComponentGallery/ComponentGallery/ReadmeSamples.swift).
The README copies its code from that file, and the package's test target compiles and renders
the same file through the symlink `Tests/SwiftUIComponentsTests/ReadmeExamples.swift`.

The project file is made with [XcodeGen](https://github.com/yonaskolb/XcodeGen) from
[`project.yml`](ComponentGallery/project.yml) and committed, so you only need XcodeGen after
editing `project.yml`.
