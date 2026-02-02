import SwiftUI

/// A multi-tag input field that allows users to add and remove tags.
///
/// Tags are displayed as removable chips. Users type in the text field
/// and press return to add a new tag.
///
/// ```swift
/// @State private var tags: [String] = ["Swift", "iOS"]
///
/// TagInput(tags: $tags, placeholder: "Add tag...")
/// ```
public struct TagInput: View {
    // MARK: - Properties

    @Binding private var tags: [String]
    private let placeholder: String
    private let tagColor: Color
    private let maxTags: Int?

    @State private var inputText: String = ""
    @FocusState private var isFocused: Bool

    // MARK: - Initialization

    /// Creates a new tag input.
    /// - Parameters:
    ///   - tags: A binding to the array of tag strings.
    ///   - placeholder: The placeholder text for the input field. Defaults to `"Add tag..."`.
    ///   - tagColor: The color for tag chips. Defaults to `.blue`.
    ///   - maxTags: Optional maximum number of tags. Defaults to `nil` (unlimited).
    public init(
        tags: Binding<[String]>,
        placeholder: String = "Add tag...",
        tagColor: Color = .blue,
        maxTags: Int? = nil
    ) {
        self._tags = tags
        self.placeholder = placeholder
        self.tagColor = tagColor
        self.maxTags = maxTags
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            FlowLayout(spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    tagChip(tag)
                }

                if canAddMore {
                    TextField(placeholder, text: $inputText)
                        .focused($isFocused)
                        .onSubmit(addTag)
                        .frame(minWidth: 80)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isFocused ? tagColor : Color.clear, lineWidth: 1.5)
            )
            .onTapGesture { isFocused = true }

            if let maxTags {
                Text("\(tags.count)/\(maxTags)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: tags)
    }

    // MARK: - Subviews

    private func tagChip(_ tag: String) -> some View {
        HStack(spacing: 4) {
            Text(tag)
                .font(.subheadline)
                .foregroundStyle(.white)

            Button {
                removeTag(tag)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white.opacity(0.8))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(tagColor))
        .transition(.scale.combined(with: .opacity))
    }

    // MARK: - Actions

    private var canAddMore: Bool {
        guard let maxTags else { return true }
        return tags.count < maxTags
    }

    private func addTag() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !tags.contains(trimmed) else {
            inputText = ""
            return
        }
        tags.append(trimmed)
        inputText = ""
    }

    private func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }
}

// MARK: - Flow Layout

/// A simple flow layout that wraps items to the next line.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            let point = CGPoint(
                x: bounds.minX + result.positions[index].x,
                y: bounds.minY + result.positions[index].y
            )
            subview.place(at: point, anchor: .topLeading, proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalSize: CGSize = .zero

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth, currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            totalSize.width = max(totalSize.width, currentX - spacing)
        }
        totalSize.height = currentY + lineHeight
        return (positions, totalSize)
    }
}

#if DEBUG
struct TagInputPreview: View {
    @State private var tags = ["Swift", "SwiftUI", "iOS"]

    var body: some View {
        TagInput(tags: $tags, maxTags: 8)
            .padding()
    }
}

#Preview {
    TagInputPreview()
}
#endif
