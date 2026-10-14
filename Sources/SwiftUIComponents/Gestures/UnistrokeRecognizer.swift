import CoreGraphics
import Foundation

/// Recognizes single-stroke drawings, such as a circle or a check mark, by comparing them with
/// templates.
///
/// It implements the $1 Unistroke Recognizer (Wobbrock, Wilson and Li, UIST 2007) with the
/// uniform scaling for one-dimensional strokes from its successor, $N, so straight lines are
/// recognized too. Recognition does not depend on where the stroke is drawn, how large it is,
/// or how it is rotated (within ±45° after normalizing the start point).
///
/// ```swift
/// let recognizer = UnistrokeRecognizer()
/// if let match = recognizer.recognize(points), match.score > 0.8 {
///     print(match.name) // "circle"
/// }
/// ```
///
/// Add your own shapes with ``add(_:points:)``; templates are `Codable`, so shapes recorded
/// in the app can be saved and loaded.
public struct UnistrokeRecognizer: Sendable {
    /// A named, normalized stroke the recognizer compares drawings with.
    public struct Template: Codable, Equatable, Sendable {
        /// The name ``Match/name`` reports, for example `"circle"`.
        public let name: String
        /// The stroke after resampling, rotation, scaling and translation.
        public let points: [CGPoint]

        /// Normalizes `points` into a template. Returns `nil` for a stroke with no length.
        public init?(name: String, points: [CGPoint]) {
            guard let normalized = Stroke.normalize(points) else { return nil }
            self.name = name
            self.points = normalized
        }
    }

    /// The best template for a drawing.
    public struct Match: Equatable, Sendable {
        /// The template name.
        public let name: String
        /// The similarity from 0 (no resemblance) to 1 (identical after normalization).
        public let score: Double
    }

    /// The shapes in ``builtInTemplates``.
    public enum BuiltInShape: String, CaseIterable, Sendable {
        case circle, rectangle, triangle, check, caret, chevronDown, zigzag, star, line
    }

    /// The templates the recognizer compares drawings with.
    public private(set) var templates: [Template]

    /// Creates a recognizer, by default with ``builtInTemplates``.
    public init(templates: [Template] = UnistrokeRecognizer.builtInTemplates) {
        self.templates = templates
    }

    /// Adds a template made from `points` under `name`. Returns `false` if the stroke has no length.
    @discardableResult
    public mutating func add(_ name: String, points: [CGPoint]) -> Bool {
        guard let template = Template(name: name, points: points) else { return false }
        templates.append(template)
        return true
    }

    /// Removes every template called `name`.
    public mutating func removeTemplates(named name: String) {
        templates.removeAll { $0.name == name }
    }

    /// Returns the closest template, or `nil` when there are no templates or the stroke has no
    /// length. Check ``Match/score`` before acting on the result; 0.8 is a reasonable threshold.
    public func recognize(_ points: [CGPoint]) -> Match? {
        guard let candidate = Stroke.normalize(points) else { return nil }
        var best: (name: String, distance: Double)?
        for template in templates {
            let distance = Stroke.distanceAtBestAngle(candidate, template.points)
            if distance < best?.distance ?? .infinity {
                best = (template.name, distance)
            }
        }
        guard let best else { return nil }
        let halfDiagonal = 0.5 * (2 * Stroke.squareSize * Stroke.squareSize).squareRoot()
        return Match(name: best.name, score: max(0, 1 - best.distance / halfDiagonal))
    }
}

// MARK: - Built-in templates

extension UnistrokeRecognizer {
    /// Templates for each ``BuiltInShape``. Closed shapes include every start corner and both
    /// drawing directions.
    public static let builtInTemplates: [Template] = BuiltInShape.allCases.flatMap { shape in
        shape.strokes.compactMap { Template(name: shape.rawValue, points: $0) }
    }
}

extension UnistrokeRecognizer.BuiltInShape {
    /// The strokes for this shape in a unit square, with y pointing down.
    var strokes: [[CGPoint]] {
        switch self {
        case .circle:
            let circle = (0...64).map { step in
                let angle = -Double.pi / 2 + Double(step) / 64 * 2 * .pi
                return CGPoint(x: cos(angle), y: sin(angle))
            }
            return [circle, circle.reversed()]
        case .rectangle:
            return Self.closedPolygonVariants([(0, 0), (1, 0), (1, 1), (0, 1)])
        case .triangle:
            return Self.closedPolygonVariants([(0.5, 0), (1, 1), (0, 1)])
        case .check:
            return [Self.polyline([(0, 0.55), (0.35, 1), (1, 0)])]
        case .caret:
            return [Self.polyline([(0, 1), (0.5, 0), (1, 1)])]
        case .chevronDown:
            return [Self.polyline([(0, 0), (0.5, 1), (1, 0)])]
        case .zigzag:
            return [Self.polyline([(0, 0), (0.25, 1), (0.5, 0), (0.75, 1), (1, 0)])]
        case .star:
            let tips = (0..<6).map { index in
                let angle = -Double.pi / 2 + Double(index * 2) * 2 * .pi / 5
                return (cos(angle), sin(angle))
            }
            let star = Self.polyline(tips)
            return [star, star.reversed()]
        case .line:
            return [Self.polyline([(0, 0.5), (1, 0.5)])]
        }
    }

    private static func polyline(_ corners: [(Double, Double)]) -> [CGPoint] {
        corners.map { CGPoint(x: $0.0, y: $0.1) }
    }

    /// Every start corner in both directions, each closed back to its first corner.
    private static func closedPolygonVariants(_ corners: [(Double, Double)]) -> [[CGPoint]] {
        let points = polyline(corners)
        return [points, Array(points.reversed())].flatMap { ordered in
            ordered.indices.map { start in
                let rotated = Array(ordered[start...] + ordered[..<start])
                return rotated + [rotated[0]]
            }
        }
    }
}

// MARK: - $1 steps

/// The normalization and matching steps of the $1 recognizer.
enum Stroke {
    static let sampleCount = 64
    static let squareSize = 250.0
    /// Strokes whose short side is at most this fraction of the long side are scaled uniformly.
    static let oneDimensionalRatio = 0.3
    static let angleRange = 45.0 * .pi / 180
    static let anglePrecision = 2.0 * .pi / 180
    static let goldenRatio = 0.5 * (-1 + 5.0.squareRoot())

    /// Resamples, rotates, scales and centers a stroke. Returns `nil` for a stroke with no
    /// length, or one whose length overflows. Points with a NaN or infinite coordinate are dropped.
    static func normalize(_ points: [CGPoint]) -> [CGPoint]? {
        let points = points.filter { $0.x.isFinite && $0.y.isFinite }
        let length = pathLength(points)
        guard length > 0, length.isFinite else { return nil }
        let resampled = resample(points, count: sampleCount)
        let rotated = rotate(resampled, by: -indicativeAngle(resampled))
        return translateToOrigin(scale(rotated))
    }

    static func pathLength(_ points: [CGPoint]) -> Double {
        zip(points, points.dropFirst()).reduce(0) { $0 + distance($1.0, $1.1) }
    }

    static func resample(_ points: [CGPoint], count: Int) -> [CGPoint] {
        let interval = pathLength(points) / Double(count - 1)
        var source = points
        var result = [points[0]]
        var accumulated = 0.0
        var index = 1
        // Stopping at `count` also ends the loop when rounding makes an inserted point equal to
        // its predecessor (coordinates near 1e16), which would otherwise insert it forever.
        while index < source.count, result.count < count {
            let segment = distance(source[index - 1], source[index])
            if segment > 0, accumulated + segment >= interval {
                let ratio = (interval - accumulated) / segment
                let point = CGPoint(
                    x: source[index - 1].x + ratio * (source[index].x - source[index - 1].x),
                    y: source[index - 1].y + ratio * (source[index].y - source[index - 1].y)
                )
                result.append(point)
                source.insert(point, at: index)
                accumulated = 0
            } else {
                accumulated += segment
            }
            index += 1
        }
        // Rounding can leave the result one point short.
        while result.count < count, let last = points.last {
            result.append(last)
        }
        return Array(result.prefix(count))
    }

    static func centroid(_ points: [CGPoint]) -> CGPoint {
        let sum = points.reduce(CGPoint.zero) { CGPoint(x: $0.x + $1.x, y: $0.y + $1.y) }
        return CGPoint(x: sum.x / Double(points.count), y: sum.y / Double(points.count))
    }

    static func indicativeAngle(_ points: [CGPoint]) -> Double {
        let center = centroid(points)
        return atan2(center.y - points[0].y, center.x - points[0].x)
    }

    static func rotate(_ points: [CGPoint], by angle: Double) -> [CGPoint] {
        let center = centroid(points)
        let cosine = cos(angle), sine = sin(angle)
        return points.map { point in
            let dx = point.x - center.x, dy = point.y - center.y
            return CGPoint(x: dx * cosine - dy * sine + center.x, y: dx * sine + dy * cosine + center.y)
        }
    }

    static func scale(_ points: [CGPoint]) -> [CGPoint] {
        let xs = points.map(\.x), ys = points.map(\.y)
        let width = (xs.max() ?? 0) - (xs.min() ?? 0)
        let height = (ys.max() ?? 0) - (ys.min() ?? 0)
        let longSide = max(width, height)
        let isOneDimensional = min(width, height) / longSide <= oneDimensionalRatio
        let scaleX = squareSize / (isOneDimensional ? longSide : max(width, .ulpOfOne))
        let scaleY = squareSize / (isOneDimensional ? longSide : max(height, .ulpOfOne))
        return points.map { CGPoint(x: $0.x * scaleX, y: $0.y * scaleY) }
    }

    static func translateToOrigin(_ points: [CGPoint]) -> [CGPoint] {
        let center = centroid(points)
        return points.map { CGPoint(x: $0.x - center.x, y: $0.y - center.y) }
    }

    /// The smallest average point distance over rotations of `candidate` within ±45°, found
    /// with a golden section search.
    static func distanceAtBestAngle(_ candidate: [CGPoint], _ template: [CGPoint]) -> Double {
        var low = -angleRange, high = angleRange
        var x1 = goldenRatio * low + (1 - goldenRatio) * high
        var x2 = (1 - goldenRatio) * low + goldenRatio * high
        var f1 = distance(rotate(candidate, by: x1), template)
        var f2 = distance(rotate(candidate, by: x2), template)
        while abs(high - low) > anglePrecision {
            if f1 < f2 {
                high = x2
                x2 = x1
                f2 = f1
                x1 = goldenRatio * low + (1 - goldenRatio) * high
                f1 = distance(rotate(candidate, by: x1), template)
            } else {
                low = x1
                x1 = x2
                f1 = f2
                x2 = (1 - goldenRatio) * low + goldenRatio * high
                f2 = distance(rotate(candidate, by: x2), template)
            }
        }
        return min(f1, f2)
    }

    /// The average distance between corresponding points.
    static func distance(_ first: [CGPoint], _ second: [CGPoint]) -> Double {
        let count = min(first.count, second.count)
        guard count > 0 else { return .infinity }
        let total = zip(first, second).reduce(0) { $0 + distance($1.0, $1.1) }
        return total / Double(count)
    }

    static func distance(_ first: CGPoint, _ second: CGPoint) -> Double {
        hypot(second.x - first.x, second.y - first.y)
    }
}
