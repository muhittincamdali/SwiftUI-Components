import SwiftUI

/// A layout that places subviews left to right and wraps to a new line
/// when the proposed width is exhausted. Used by chips, tags and multi-select fields.
public struct FlowLayout: Layout {
    public var spacing: CGFloat

    public init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return Self.arrange(sizes: sizes, maxWidth: proposal.width ?? .infinity, spacing: spacing).size
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let result = Self.arrange(sizes: sizes, maxWidth: bounds.width, spacing: spacing)
        for (subview, position) in zip(subviews, result.positions) {
            subview.place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                anchor: .topLeading,
                proposal: .unspecified
            )
        }
    }

    /// Computes the top-leading origin of every item and the total size of the flow.
    ///
    /// An item that does not fit on the current line moves to the next one, unless it is
    /// the first item on the line (an oversized item still gets its own line).
    public static func arrange(
        sizes: [CGSize],
        maxWidth: CGFloat,
        spacing: CGFloat
    ) -> (positions: [CGPoint], size: CGSize) {
        var positions: [CGPoint] = []
        positions.reserveCapacity(sizes.count)
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalWidth: CGFloat = 0

        for size in sizes {
            if currentX > 0, currentX + size.width > maxWidth {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            totalWidth = max(totalWidth, currentX + size.width)
            currentX += size.width + spacing
        }

        return (positions, CGSize(width: totalWidth, height: currentY + lineHeight))
    }
}
