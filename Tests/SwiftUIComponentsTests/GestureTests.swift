import Foundation
import SwiftUI
import Testing
@testable import SwiftUIComponents

@Suite("Swipe and drag rules")
struct GestureRuleTests {
    @Test("classifies straight swipes", arguments: [
        (CGSize(width: 80, height: 0), SwipeDirection.right),
        (CGSize(width: -80, height: 0), .left),
        (CGSize(width: 0, height: -80), .up),
        (CGSize(width: 0, height: 80), .down),
        (CGSize(width: 80, height: 40), .right),   // 26.6° below the axis
        (CGSize(width: -40, height: -80), .up),    // 26.6° from vertical
    ])
    func classifies(translation: CGSize, expected: SwipeDirection) {
        #expect(SwipeDirection.classify(translation) == expected)
    }

    @Test func rejectsShortAndDiagonalDrags() {
        #expect(SwipeDirection.classify(CGSize(width: 49, height: 0)) == nil)
        #expect(SwipeDirection.classify(.zero, minimumDistance: 0) == nil)
        #expect(SwipeDirection.classify(CGSize(width: 60, height: 60)) == nil) // 45°
        #expect(SwipeDirection.classify(CGSize(width: 60, height: 60), tolerance: .degrees(45)) != nil)
        #expect(SwipeDirection.classify(CGSize(width: 10, height: 0), minimumDistance: 5) == .right)
    }

    @Test func toleranceIsClampedToFortyFiveDegrees() {
        // 60° from horizontal: with an unclamped 90° tolerance it would count as .right.
        let steep = CGSize(width: 50, height: -86.6)
        #expect(SwipeDirection.classify(steep, tolerance: .degrees(90)) == .up)
        #expect(SwipeDirection.classify(CGSize(width: 100, height: 1), tolerance: .degrees(-10)) == nil)
    }

    @Test func edgeSwipeNeedsAnEdgeStartAndEnoughTravel() {
        let size = CGSize(width: 390, height: 844)
        #expect(EdgeSwipe.recognizes(start: CGPoint(x: 10, y: 400), translation: CGSize(width: 70, height: 5), in: size, edge: .leading))
        #expect(!EdgeSwipe.recognizes(start: CGPoint(x: 30, y: 400), translation: CGSize(width: 70, height: 5), in: size, edge: .leading))
        #expect(!EdgeSwipe.recognizes(start: CGPoint(x: 10, y: 400), translation: CGSize(width: 59, height: 0), in: size, edge: .leading))
        #expect(EdgeSwipe.recognizes(start: CGPoint(x: 380, y: 400), translation: CGSize(width: -60, height: 0), in: size, edge: .trailing))
        #expect(!EdgeSwipe.recognizes(start: CGPoint(x: 380, y: 400), translation: CGSize(width: 60, height: 0), in: size, edge: .trailing))
        #expect(EdgeSwipe.recognizes(start: CGPoint(x: 200, y: 4), translation: CGSize(width: 0, height: 90), in: size, edge: .top))
        #expect(EdgeSwipe.recognizes(start: CGPoint(x: 200, y: 830), translation: CGSize(width: 0, height: -90), in: size, edge: .bottom))
        #expect(!EdgeSwipe.recognizes(start: CGPoint(x: 200, y: 800), translation: CGSize(width: 0, height: -90), in: size, edge: .bottom))
    }

    @Test func transformClampsScaleAndAccumulates() {
        let start = TransformState(scale: 2, rotation: .degrees(10), offset: CGSize(width: 5, height: 5))
        let moved = start.applying(magnification: 3, rotation: .degrees(20), translation: CGSize(width: 10, height: -5), scaleRange: 1...4)
        #expect(moved.scale == 4)
        #expect(abs(moved.rotation.degrees - 30) < 1e-9)
        #expect(moved.offset == CGSize(width: 15, height: 0))
        #expect(start.applying(magnification: 0.1).scale == 1)
        #expect(start.applying(magnification: .infinity).scale == 2)
        #expect(start.applying(magnification: .nan).scale == 2)
        #expect(TransformState.identity.applying() == .identity)
    }

    @Test func dragBoundsClampToTheNearestPoint() {
        let track = CGRect(x: -100, y: 0, width: 200, height: 0)
        #expect(DragBounds.clamp(CGSize(width: 150, height: 30), to: track) == CGSize(width: 100, height: 0))
        #expect(DragBounds.clamp(CGSize(width: -20, height: -30), to: track) == CGSize(width: -20, height: 0))
        // A rectangle with negative size is treated like its standardized form.
        let flipped = CGRect(x: 50, y: 50, width: -100, height: -100)
        #expect(DragBounds.clamp(CGSize(width: -80, height: 80), to: flipped) == CGSize(width: -50, height: 50))
    }

    @Test func swipeSequenceMatchesWithinTheTimeLimit() {
        var matcher = SwipeSequenceMatcher([.up, .up, .down], within: 2)
        let start = Date(timeIntervalSinceReferenceDate: 0)
        let afterFirstUp = matcher.register(.up, at: start)
        #expect(!afterFirstUp)
        let afterSecondUp = matcher.register(.up, at: start + 0.5)
        #expect(!afterSecondUp)
        let afterDown = matcher.register(.down, at: start + 1)
        #expect(afterDown)
        // The history was cleared, so one more swipe does not match again.
        let afterExtraDown = matcher.register(.down, at: start + 1.2)
        #expect(!afterExtraDown)
    }

    @Test func swipeSequenceRecoversFromWrongAndSlowInput() {
        var matcher = SwipeSequenceMatcher([.left, .right], within: 1)
        let start = Date(timeIntervalSinceReferenceDate: 0)
        let afterLeft = matcher.register(.left, at: start)
        #expect(!afterLeft)
        let afterRepeatedLeft = matcher.register(.left, at: start + 0.2)   // repeated first swipe
        #expect(!afterRepeatedLeft)
        let afterRight = matcher.register(.right, at: start + 0.4)   // matches with the second left
        #expect(afterRight)

        let afterLateLeft = matcher.register(.left, at: start + 10)
        #expect(!afterLateLeft)
        let afterSlowRight = matcher.register(.right, at: start + 11.5) // too slow
        #expect(!afterSlowRight)

        var empty = SwipeSequenceMatcher([])
        let emptyMatched = empty.register(.up)
        #expect(!emptyMatched)
    }
}

/// A deterministic random number generator, so the noisy strokes are the same on every run.
private struct SeededGenerator: RandomNumberGenerator {
    var state: UInt64
    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}

@Suite("UnistrokeRecognizer")
struct UnistrokeRecognizerTests {
    let recognizer = UnistrokeRecognizer()

    /// Points along straight segments between `corners`, with up to `noise` points of jitter.
    private func stroke(through corners: [CGPoint], pointsPerSegment: Int = 12, noise: Double = 3, seed: UInt64 = 1) -> [CGPoint] {
        var generator = SeededGenerator(state: seed)
        var points: [CGPoint] = []
        for (from, to) in zip(corners, corners.dropFirst()) {
            for step in 0..<pointsPerSegment {
                let t = Double(step) / Double(pointsPerSegment)
                points.append(CGPoint(
                    x: from.x + (to.x - from.x) * t + Double.random(in: -noise...noise, using: &generator),
                    y: from.y + (to.y - from.y) * t + Double.random(in: -noise...noise, using: &generator)
                ))
            }
        }
        points.append(corners[corners.count - 1])
        return points
    }

    private func circle(center: CGPoint, radius: Double, startDegrees: Double, clockwise: Bool, seed: UInt64 = 2) -> [CGPoint] {
        var generator = SeededGenerator(state: seed)
        return (0...48).map { step in
            let sweep = Double(step) / 48 * 2 * .pi * (clockwise ? 1 : -1)
            let angle = startDegrees * .pi / 180 + sweep
            let jitter = Double.random(in: -4...4, using: &generator)
            return CGPoint(x: center.x + (radius + jitter) * cos(angle), y: center.y + (radius + jitter) * sin(angle))
        }
    }

    private func expect(_ points: [CGPoint], recognizedAs name: String, sourceLocation: SourceLocation = #_sourceLocation) {
        let match = recognizer.recognize(points)
        #expect(match?.name == name, sourceLocation: sourceLocation)
        #expect((match?.score ?? 0) > 0.8, "score \(match?.score ?? 0)", sourceLocation: sourceLocation)
    }

    @Test func recognizesCirclesOfAnySizeStartAndDirection() {
        expect(circle(center: CGPoint(x: 200, y: 300), radius: 80, startDegrees: 0, clockwise: true), recognizedAs: "circle")
        expect(circle(center: CGPoint(x: 40, y: 40), radius: 25, startDegrees: 135, clockwise: false), recognizedAs: "circle")
    }

    @Test func recognizesRectanglesFromAnyCorner() {
        let corners = [CGPoint(x: 0, y: 0), CGPoint(x: 220, y: 0), CGPoint(x: 220, y: 140), CGPoint(x: 0, y: 140)]
        expect(stroke(through: corners + [corners[0]]), recognizedAs: "rectangle")
        let fromBottomRight = [corners[2], corners[1], corners[0], corners[3], corners[2]]
        expect(stroke(through: fromBottomRight, seed: 9), recognizedAs: "rectangle")
    }

    @Test func recognizesTrianglesChecksAndCarets() {
        expect(stroke(through: [CGPoint(x: 0, y: 200), CGPoint(x: 100, y: 0), CGPoint(x: 200, y: 200), CGPoint(x: 0, y: 200)]), recognizedAs: "triangle")
        expect(stroke(through: [CGPoint(x: 0, y: 50), CGPoint(x: 40, y: 100), CGPoint(x: 120, y: 0)], noise: 2), recognizedAs: "check")
        expect(stroke(through: [CGPoint(x: 0, y: 100), CGPoint(x: 50, y: 0), CGPoint(x: 100, y: 100)], noise: 2), recognizedAs: "caret")
        expect(stroke(through: [CGPoint(x: 0, y: 0), CGPoint(x: 50, y: 100), CGPoint(x: 100, y: 0)], noise: 2), recognizedAs: "chevronDown")
    }

    @Test func recognizesZigzagsStarsAndLines() {
        expect(stroke(through: [CGPoint(x: 0, y: 0), CGPoint(x: 40, y: 80), CGPoint(x: 80, y: 0), CGPoint(x: 120, y: 80), CGPoint(x: 160, y: 0)], noise: 2), recognizedAs: "zigzag")
        let tips = (0..<6).map { index -> CGPoint in
            let angle = -Double.pi / 2 + Double(index * 2) * 2 * .pi / 5
            return CGPoint(x: 150 + 100 * cos(angle), y: 150 + 100 * sin(angle))
        }
        expect(stroke(through: tips, noise: 2), recognizedAs: "star")
        expect(stroke(through: [CGPoint(x: 10, y: 10), CGPoint(x: 210, y: 160)], noise: 1.5), recognizedAs: "line")
    }

    @Test func returnsNilForStrokesWithoutLength() {
        #expect(recognizer.recognize([]) == nil)
        #expect(recognizer.recognize([CGPoint(x: 5, y: 5)]) == nil)
        #expect(recognizer.recognize(Array(repeating: CGPoint(x: 5, y: 5), count: 20)) == nil)
        #expect(UnistrokeRecognizer(templates: []).recognize([.zero, CGPoint(x: 10, y: 10)]) == nil)
    }

    /// Points from the app or a broken input device must not stop the process or poison the
    /// result with NaN.
    @Test func ignoresNonFiniteAndExtremePoints() throws {
        let line = (0...20).map { CGPoint(x: Double($0) * 10, y: 0) }
        let withJunk = [CGPoint(x: CGFloat.nan, y: 0)] + line + [CGPoint(x: CGFloat.infinity, y: 5)]
        let match = try #require(recognizer.recognize(withJunk))
        #expect(match.name == "line")
        #expect(match.score.isFinite)

        // A path whose length overflows Double is treated as having no length.
        #expect(recognizer.recognize([CGPoint(x: -1e308, y: 0), CGPoint(x: 1e308, y: 0)]) == nil)
    }

    @Test func customTemplatesAreRecognizedAndSurviveCoding() throws {
        // An "S" drawn from the top right.
        let shape = [CGPoint(x: 100, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 50), CGPoint(x: 100, y: 50), CGPoint(x: 100, y: 100), CGPoint(x: 0, y: 100)]
        var custom = UnistrokeRecognizer(templates: [])
        let addedShape = custom.add("s", points: stroke(through: shape, noise: 0))
        #expect(addedShape)
        let addedDot = custom.add("dot", points: [CGPoint(x: 1, y: 1)])
        #expect(!addedDot)

        let data = try JSONEncoder().encode(custom.templates)
        let restored = UnistrokeRecognizer(templates: try JSONDecoder().decode([UnistrokeRecognizer.Template].self, from: data))
        let match = restored.recognize(stroke(through: shape.map { CGPoint(x: $0.x * 1.5 + 30, y: $0.y * 1.5) }, noise: 3, seed: 4))
        #expect(match?.name == "s")
        #expect((match?.score ?? 0) > 0.8)

        custom.removeTemplates(named: "s")
        #expect(custom.templates.isEmpty)
    }

    @Test func builtInTemplatesCoverEveryShape() {
        let names = Set(UnistrokeRecognizer.builtInTemplates.map(\.name))
        #expect(names == Set(UnistrokeRecognizer.BuiltInShape.allCases.map(\.rawValue)))
        #expect(UnistrokeRecognizer.builtInTemplates.allSatisfy { $0.points.count == 64 })
    }

    @Test func aScribbleScoresLowerThanARealShape() {
        var generator = SeededGenerator(state: 42)
        let scribble = (0..<60).map { _ in
            CGPoint(x: Double.random(in: 0...200, using: &generator), y: Double.random(in: 0...200, using: &generator))
        }
        let scribbleScore = recognizer.recognize(scribble)?.score ?? 0
        let circleScore = recognizer.recognize(circle(center: .zero, radius: 60, startDegrees: 30, clockwise: true))?.score ?? 0
        #expect(scribbleScore < 0.75)
        #expect(circleScore > scribbleScore)
    }
}

@MainActor
@Suite("ShapeDrawingPad stroke")
struct ShapeDrawingPadStrokeTests {
    /// A finger held down for minutes keeps sending points; the stroke must stay bounded.
    @Test func keepsAtMostTheMaximumNumberOfPoints() {
        var points: [CGPoint] = []
        for index in 0..<10_000 {
            ShapeDrawingPad.append(CGPoint(x: Double(index) * 2, y: 0), to: &points)
        }
        #expect(points.count <= ShapeDrawingPad.maximumPointCount)
        #expect(points.count > ShapeDrawingPad.maximumPointCount / 2)
        #expect(points.first == .zero) // halving keeps the start of the stroke
    }

    @Test func skipsTinyMovesAndNonFinitePoints() {
        var points: [CGPoint] = []
        ShapeDrawingPad.append(.zero, to: &points)
        ShapeDrawingPad.append(CGPoint(x: 0.5, y: 0.5), to: &points)
        ShapeDrawingPad.append(CGPoint(x: CGFloat.nan, y: 3), to: &points)
        ShapeDrawingPad.append(CGPoint(x: 3, y: CGFloat.infinity), to: &points)
        ShapeDrawingPad.append(CGPoint(x: 3, y: 4), to: &points)
        #expect(points == [.zero, CGPoint(x: 3, y: 4)])
    }
}
