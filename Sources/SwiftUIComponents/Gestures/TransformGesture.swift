import SwiftUI

/// The scale, rotation and offset that ``SwiftUICore/View/transformable(_:scaleRange:allowsRotation:allowsPanning:doubleTapToReset:)``
/// applies to a view.
public struct TransformState: Equatable, Sendable {
    public var scale: CGFloat
    public var rotation: Angle
    public var offset: CGSize

    /// No scaling, rotation or offset.
    public static let identity = TransformState()

    public init(scale: CGFloat = 1, rotation: Angle = .zero, offset: CGSize = .zero) {
        self.scale = scale
        self.rotation = rotation
        self.offset = offset
    }

    /// Returns this state with an in-progress gesture applied on top of it.
    ///
    /// - Parameters:
    ///   - magnification: The gesture's scale factor; `1` leaves the scale unchanged.
    ///   - rotation: The angle to add.
    ///   - translation: The distance to add to the offset.
    ///   - scaleRange: The resulting scale is clamped to this range.
    public func applying(
        magnification: CGFloat = 1,
        rotation: Angle = .zero,
        translation: CGSize = .zero,
        scaleRange: ClosedRange<CGFloat> = 1...4
    ) -> TransformState {
        let scaled = scale * magnification
        return TransformState(
            scale: scaled.isFinite ? min(max(scaled, scaleRange.lowerBound), scaleRange.upperBound) : scale,
            rotation: self.rotation + rotation,
            offset: CGSize(width: offset.width + translation.width, height: offset.height + translation.height)
        )
    }
}

private struct TransformModifier: ViewModifier {
    @Binding var state: TransformState
    let scaleRange: ClosedRange<CGFloat>
    let allowsRotation: Bool
    let allowsPanning: Bool
    let doubleTapToReset: Bool

    /// The state when the current gestures began.
    @State private var base = TransformState.identity
    @State private var magnification: CGFloat = 1
    @State private var rotation: Angle = .zero
    @State private var translation: CGSize = .zero

    private var isIdle: Bool {
        magnification == 1 && rotation == .zero && translation == .zero
    }

    func body(content: Content) -> some View {
        content
            .scaleEffect(state.scale)
            .rotationEffect(state.rotation)
            .offset(state.offset)
            .gesture(transformGesture)
            .onTapGesture(count: 2) {
                guard doubleTapToReset else { return }
                withAnimation(.spring) { state = .identity }
            }
            .accessibilityZoomAction { action in
                let factor: CGFloat = action.direction == .zoomIn ? 1.25 : 0.8
                state = state.applying(magnification: factor, scaleRange: scaleRange)
            }
    }

    private var transformGesture: some Gesture {
        let magnify = MagnifyGesture()
            .onChanged { value in
                begin()
                magnification = value.magnification
                update()
            }
            .onEnded { _ in
                base = base.applying(magnification: magnification, scaleRange: scaleRange)
                magnification = 1
            }
        let rotate = RotateGesture()
            .onChanged { value in
                guard allowsRotation else { return }
                begin()
                rotation = value.rotation
                update()
            }
            .onEnded { _ in
                base = base.applying(rotation: rotation, scaleRange: scaleRange)
                rotation = .zero
            }
        let pan = DragGesture()
            .onChanged { value in
                guard allowsPanning else { return }
                begin()
                translation = value.translation
                update()
            }
            .onEnded { _ in
                base = base.applying(translation: translation, scaleRange: scaleRange)
                translation = .zero
            }
        return magnify.simultaneously(with: rotate).simultaneously(with: pan)
    }

    /// Picks up changes made to the binding from outside, such as a reset button.
    private func begin() {
        if isIdle { base = state }
    }

    private func update() {
        state = base.applying(
            magnification: magnification,
            rotation: rotation,
            translation: translation,
            scaleRange: scaleRange
        )
    }
}

extension View {
    /// Lets the user pinch to zoom, rotate with two fingers and drag the view, and stores the
    /// result in `state`.
    ///
    /// On a Mac the same gestures work with a trackpad. VoiceOver users can zoom with the
    /// accessibility zoom action.
    ///
    /// ```swift
    /// @State private var transform = TransformState.identity
    ///
    /// Image("map")
    ///     .resizable()
    ///     .scaledToFit()
    ///     .transformable($transform, scaleRange: 1...5)
    /// ```
    ///
    /// - Parameters:
    ///   - state: The current transform. Set it to ``TransformState/identity`` to reset.
    ///   - scaleRange: The smallest and largest allowed scale.
    ///   - allowsRotation: Whether a two-finger rotation turns the view.
    ///   - allowsPanning: Whether dragging moves the view.
    ///   - doubleTapToReset: Whether a double tap animates back to ``TransformState/identity``.
    public func transformable(
        _ state: Binding<TransformState>,
        scaleRange: ClosedRange<CGFloat> = 1...4,
        allowsRotation: Bool = true,
        allowsPanning: Bool = true,
        doubleTapToReset: Bool = true
    ) -> some View {
        modifier(TransformModifier(
            state: state,
            scaleRange: scaleRange,
            allowsRotation: allowsRotation,
            allowsPanning: allowsPanning,
            doubleTapToReset: doubleTapToReset
        ))
    }
}
