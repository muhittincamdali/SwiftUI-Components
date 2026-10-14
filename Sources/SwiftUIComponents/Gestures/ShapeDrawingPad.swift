import SwiftUI

/// An area the user draws a single stroke on; when the finger lifts, the stroke is matched
/// against a ``UnistrokeRecognizer``.
///
/// ```swift
/// ShapeDrawingPad { match in
///     guard let match else { return }
///     if match.name == "check" { markDone() }
/// }
/// .frame(height: 240)
/// ```
///
/// Drawing is not available to VoiceOver users. Offer the same command another way, for
/// example a button, or pass `accessibilityAlternatives` to add named accessibility actions
/// that report a match directly.
public struct ShapeDrawingPad: View {
    private let recognizer: UnistrokeRecognizer
    private let minimumScore: Double
    private let strokeColor: Color
    private let lineWidth: CGFloat
    private let accessibilityAlternatives: [String]
    private let onRecognize: (UnistrokeRecognizer.Match?) -> Void

    @State private var points: [CGPoint] = []

    /// Creates a drawing pad.
    ///
    /// - Parameters:
    ///   - recognizer: The templates to match against.
    ///   - minimumScore: Matches with a lower score are reported as `nil`.
    ///   - strokeColor: The color of the drawn line.
    ///   - lineWidth: The width of the drawn line.
    ///   - accessibilityAlternatives: Template names offered as accessibility actions; choosing
    ///     one calls `onRecognize` with that name and a score of 1.
    ///   - onRecognize: Called when the finger lifts, with the match or `nil`.
    public init(
        recognizer: UnistrokeRecognizer = UnistrokeRecognizer(),
        minimumScore: Double = 0.75,
        strokeColor: Color = .accentColor,
        lineWidth: CGFloat = 4,
        accessibilityAlternatives: [String] = [],
        onRecognize: @escaping (UnistrokeRecognizer.Match?) -> Void
    ) {
        self.recognizer = recognizer
        self.minimumScore = minimumScore
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
        self.accessibilityAlternatives = accessibilityAlternatives
        self.onRecognize = onRecognize
    }

    public var body: some View {
        Canvas { context, _ in
            var path = Path()
            path.addLines(points)
            context.stroke(
                path,
                with: .color(strokeColor),
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
            )
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if value.translation == .zero { points = [] }
                    Self.append(value.location, to: &points)
                }
                .onEnded { _ in
                    let match = recognizer.recognize(points)
                    onRecognize(match.flatMap { $0.score >= minimumScore ? $0 : nil })
                }
        )
        .accessibilityElement()
        .accessibilityLabel("Drawing area")
        .accessibilityActions {
            ForEach(accessibilityAlternatives, id: \.self) { name in
                Button(name) {
                    onRecognize(UnistrokeRecognizer.Match(name: name, score: 1))
                }
            }
        }
    }
}

extension ShapeDrawingPad {
    /// The most points one stroke keeps. A finger held down for minutes would otherwise grow
    /// the stroke, and the cost of drawing and recognizing it, without limit.
    static let maximumPointCount = 2_048

    /// Adds `point` to a stroke, skipping points less than one point away from the last one.
    /// When the stroke reaches ``maximumPointCount`` every second point is dropped, which keeps
    /// its shape and halves its size.
    static func append(_ point: CGPoint, to points: inout [CGPoint]) {
        guard point.x.isFinite, point.y.isFinite else { return }
        if let last = points.last, hypot(point.x - last.x, point.y - last.y) < 1 { return }
        if points.count >= maximumPointCount {
            points = points.enumerated().compactMap { $0.offset.isMultiple(of: 2) ? $0.element : nil }
        }
        points.append(point)
    }
}
