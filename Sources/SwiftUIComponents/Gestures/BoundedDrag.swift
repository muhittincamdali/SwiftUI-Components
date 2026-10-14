import SwiftUI

/// Keeps a drag offset inside a rectangle. Used by
/// ``SwiftUICore/View/boundedDrag(offset:in:onEnded:)``.
public enum DragBounds {
    /// Returns `offset` moved to the nearest point inside `bounds`.
    ///
    /// `bounds` is in offset space: `CGRect(x: -100, y: 0, width: 200, height: 0)` allows a
    /// horizontal offset from -100 to 100 and no vertical movement.
    ///
    /// A NaN component counts as 0, and `CGRect.null` or bounds with a NaN coordinate allow no
    /// movement, so the result can always be passed to `offset(_:)`.
    public static func clamp(_ offset: CGSize, to bounds: CGRect) -> CGSize {
        let rect = bounds.standardized
        let coordinates = [rect.minX, rect.maxX, rect.minY, rect.maxY]
        guard !rect.isNull, !coordinates.contains(where: \.isNaN) else { return .zero }
        return CGSize(
            width: min(max(offset.width.isNaN ? 0 : offset.width, rect.minX), rect.maxX),
            height: min(max(offset.height.isNaN ? 0 : offset.height, rect.minY), rect.maxY)
        )
    }
}

private struct BoundedDragModifier: ViewModifier {
    @Binding var offset: CGSize
    let bounds: CGRect
    let onEnded: ((CGSize) -> Void)?

    @State private var start: CGSize?

    func body(content: Content) -> some View {
        content
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let origin = start ?? offset
                        start = origin
                        offset = DragBounds.clamp(
                            CGSize(
                                width: origin.width + value.translation.width,
                                height: origin.height + value.translation.height
                            ),
                            to: bounds
                        )
                    }
                    .onEnded { _ in
                        start = nil
                        onEnded?(offset)
                    }
            )
    }
}

extension View {
    /// Lets the user drag the view while keeping its offset inside `bounds`.
    ///
    /// ```swift
    /// @State private var knob = CGSize.zero
    ///
    /// Circle()
    ///     .frame(width: 44, height: 44)
    ///     .boundedDrag(offset: $knob, in: CGRect(x: -120, y: 0, width: 240, height: 0))
    /// ```
    ///
    /// - Parameters:
    ///   - offset: The current offset, applied to the view with `offset(_:)`.
    ///   - bounds: The allowed offsets; see ``DragBounds/clamp(_:to:)``.
    ///   - onEnded: Called with the final offset when the user lifts the finger.
    public func boundedDrag(
        offset: Binding<CGSize>,
        in bounds: CGRect,
        onEnded: ((CGSize) -> Void)? = nil
    ) -> some View {
        modifier(BoundedDragModifier(offset: offset, bounds: bounds, onEnded: onEnded))
    }
}
