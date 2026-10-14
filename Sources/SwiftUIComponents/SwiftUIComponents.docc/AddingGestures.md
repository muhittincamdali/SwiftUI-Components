# Adding Gestures

Respond to swipes, edge swipes and swipe sequences, let the user pinch, rotate and drag a view,
and recognize shapes drawn with a finger, with an accessible alternative for each.

## Overview

The gesture modifiers wrap SwiftUI's `DragGesture`, `MagnifyGesture` and `RotateGesture` and
keep the decisions in small types you can test: `SwipeDirection/classify(_:minimumDistance:tolerance:)`,
`SwipeSequenceMatcher`, `EdgeSwipe/recognizes(start:translation:in:edge:edgeWidth:minimumDistance:)`,
`TransformState` and `DragBounds`. Each modifier also adds an accessibility action, because
VoiceOver and Switch Control users cannot perform a swipe or a pinch.

## Respond to a swipe

`onSwipe` reports the direction of a swipe that travels at least `minimumDistance` points
within `tolerance` of an axis. A short, fast flick counts too, because the modifier also
looks at the predicted end of the drag:

```swift
Text("Card \(card)")
    .onSwipe([.left, .right]) { direction in
        card += direction == .left ? 1 : -1
    }
```

VoiceOver users get "Swipe left" and "Swipe right" in the actions rotor, which call the same
closure.

Two related modifiers:

- `onEdgeSwipe(from:accessibilityActionName:perform:)` fires once when a drag starts within
  `edgeWidth` points of an edge and moves inward, for example to open a side menu.
- `onSwipeSequence(_:within:accessibilityActionName:perform:)` fires when the user swipes the
  given directions in order within a time limit; wrong or slow input starts over.

## Pinch, rotate and drag

`transformable` applies a `TransformState` (scale, rotation and offset) to the view and
updates it from simultaneous pinch, rotation and drag gestures. The scale stays within
`scaleRange`, and a double tap resets everything:

```swift
@State private var zoom = TransformState.identity

Image(systemName: "map")
    .font(.system(size: 64))
    .transformable($zoom, scaleRange: 1...5)
```

The view gets the system zoom accessibility action, which scales by 25 percent per step.
Because the state is a binding, you can save it, animate it or reset it from a button.

To keep a dragged view inside an area, use `boundedDrag(offset:in:)`; `DragBounds/clamp(_:to:)`
is the rule it applies.

## Recognize a drawn shape

`ShapeDrawingPad` collects one stroke and, when the finger lifts, compares it with the
templates of a `UnistrokeRecognizer`. The built-in templates are a circle, rectangle,
triangle, check mark, caret, chevron, zigzag, star and line, and a match does not depend on
where the shape is drawn, how large it is, or (within 45 degrees) how it is rotated:

```swift
ShapeDrawingPad(accessibilityAlternatives: ["check"]) { match in
    guard let match else { return }
    if match.name == "check" { markDone() }
}
.frame(height: 200)
```

`accessibilityAlternatives` adds a named accessibility action per template, which reports a
match with a score of 1. Offer the same command another way as well, for example a button.

The recognizer works without a view, so you can use it with points from any source:

```swift
var recognizer = UnistrokeRecognizer()
recognizer.add("lightning", points: recordedPoints)
if let match = recognizer.recognize(points), match.score > 0.8 {
    print(match.name)
}
```

Templates are `Codable`, so shapes recorded in the app can be saved and loaded. The pad keeps at
most 2,048 points per stroke, dropping every second point when it reaches the limit, so holding
a finger down does not grow memory or recognition time without bound.

## Test your gesture logic

The decision types are plain values, so a unit test can check them without a screen:

```swift
#expect(SwipeDirection.classify(CGSize(width: -120, height: 10)) == .left)
#expect(SwipeDirection.classify(CGSize(width: 20, height: 5)) == nil) // too short

var matcher = SwipeSequenceMatcher([.up, .up, .down], within: 2)
let start = Date()
#expect(!matcher.register(.up, at: start))
#expect(!matcher.register(.up, at: start + 0.3))
#expect(matcher.register(.down, at: start + 0.6))
```
