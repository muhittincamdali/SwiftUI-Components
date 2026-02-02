import SwiftUI

/// A circular progress indicator with customizable gradient colors and line width.
///
/// Use `ProgressRing` to display a determinate progress state in a ring shape.
///
/// ```swift
/// ProgressRing(progress: 0.75, lineWidth: 8, gradient: [.blue, .purple])
///     .frame(width: 100, height: 100)
/// ```
public struct ProgressRing: View {
    // MARK: - Properties

    private let progress: Double
    private let lineWidth: CGFloat
    private let gradient: [Color]
    private let backgroundColor: Color
    private let lineCap: CGLineCap

    // MARK: - Initialization

    /// Creates a new progress ring.
    /// - Parameters:
    ///   - progress: The progress value between `0.0` and `1.0`.
    ///   - lineWidth: The width of the ring stroke. Defaults to `8`.
    ///   - gradient: An array of colors for the progress arc. Defaults to `[.blue, .cyan]`.
    ///   - backgroundColor: The color for the track ring. Defaults to a light gray.
    ///   - lineCap: The line cap style for the stroke. Defaults to `.round`.
    public init(
        progress: Double,
        lineWidth: CGFloat = 8,
        gradient: [Color] = [.blue, .cyan],
        backgroundColor: Color = Color(.systemGray5),
        lineCap: CGLineCap = .round
    ) {
        self.progress = min(max(progress, 0), 1)
        self.lineWidth = lineWidth
        self.gradient = gradient
        self.backgroundColor = backgroundColor
        self.lineCap = lineCap
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            // Background track
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)

            // Progress arc
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: gradient,
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360 * progress)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.4), value: progress)
        }
        .padding(lineWidth / 2)
    }
}

#if DEBUG
#Preview {
    HStack(spacing: 24) {
        ProgressRing(progress: 0.25, gradient: [.red, .orange])
            .frame(width: 80, height: 80)

        ProgressRing(progress: 0.65, lineWidth: 12, gradient: [.green, .mint])
            .frame(width: 100, height: 100)

        ProgressRing(progress: 0.9, gradient: [.purple, .pink])
            .frame(width: 60, height: 60)
    }
}
#endif
