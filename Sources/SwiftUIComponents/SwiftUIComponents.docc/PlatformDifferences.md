# Platform Differences

What changes when the same component runs on macOS instead of iOS.

## Overview

The components are written against SwiftUI and compile for both iOS 17 and macOS 14. A few
UIKit-only features have no AppKit counterpart; on macOS those are mapped to the closest
equivalent or skipped:

| Feature                                                        | iOS                                                     | macOS                                                        |
| -------------------------------------------------------------- | ------------------------------------------------------- | ------------------------------------------------------------ |
| System background and gray colors                              | `UIColor.systemBackground`, `systemGray2`…`systemGray6` | `NSColor.windowBackgroundColor` and translucent `systemGray` |
| Haptic feedback (segmented control, tab bar, reorderable list) | `UIImpactFeedbackGenerator`                             | none                                                         |
| Software keyboard type (``KeyboardKind``)                      | `keyboardType(_:)`                                      | ignored                                                      |
| Auto-capitalization                                            | `textInputAutocapitalization(_:)`                       | ignored                                                      |
| Wheel pickers in ``DateField`` and ``DurationPicker``          | `.wheel`                                                | stepper field / pop-up menu                                  |
| ``TestimonialCarousel`` paging                                 | page-style `TabView`                                    | one card at a time, dots select the page                     |

The README screenshots are rendered on the iOS simulator.

## Corner rounding

`View.cornerRadius(_:corners:)` takes a `UIRectCorner` and is therefore only available on iOS.
