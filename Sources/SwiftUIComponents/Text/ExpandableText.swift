import SwiftUI

/// An expandable/collapsible text view
public struct ExpandableText: View {
    let text: String
    let lineLimit: Int
    let expandButtonText: String
    let collapseButtonText: String
    let font: Font
    let textColor: Color

    @State private var isExpanded = false
    @State private var fullHeight: CGFloat = 0
    @State private var collapsedHeight: CGFloat = 0

    private var isTruncated: Bool {
        isExpanded || fullHeight > collapsedHeight + 0.5
    }

    public init(
        _ text: String,
        lineLimit: Int = 3,
        expandButtonText: String = "Read more",
        collapseButtonText: String = "Show less",
        font: Font = .body,
        textColor: Color = .primary
    ) {
        self.text = text
        self.lineLimit = lineLimit
        self.expandButtonText = expandButtonText
        self.collapseButtonText = collapseButtonText
        self.font = font
        self.textColor = textColor
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(text)
                .font(font)
                .foregroundColor(textColor)
                .lineLimit(isExpanded ? nil : lineLimit)
                .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { height in
                    if !isExpanded { collapsedHeight = height }
                }
                .background(alignment: .topLeading) {
                    // Unconstrained copy, laid out at the same width, to detect truncation.
                    Text(text)
                        .font(font)
                        .fixedSize(horizontal: false, vertical: true)
                        .hidden()
                        .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { fullHeight = $0 }
                }

            if isTruncated {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Text(isExpanded ? collapseButtonText : expandButtonText)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

/// Rich text with inline formatting
public struct RichText: View {
    let text: String
    let baseFont: Font
    let baseColor: Color

    public init(_ text: String, font: Font = .body, color: Color = .primary) {
        self.text = text
        self.baseFont = font
        self.baseColor = color
    }

    public var body: some View {
        // Simple markdown-like parsing
        Text(parseText())
            .font(baseFont)
            .foregroundColor(baseColor)
    }

    private func parseText() -> AttributedString {
        var attributedString = AttributedString(text)

        // Bold: **text**
        if let boldRange = attributedString.range(of: "\\*\\*(.+?)\\*\\*", options: .regularExpression) {
            attributedString[boldRange].inlinePresentationIntent = .stronglyEmphasized
        }

        // Italic: *text*
        if let italicRange = attributedString.range(of: "\\*(.+?)\\*", options: .regularExpression) {
            attributedString[italicRange].inlinePresentationIntent = .emphasized
        }

        return attributedString
    }
}

/// Text with reading time indicator
public struct ReadingTimeText: View {
    let text: String
    let wordsPerMinute: Int
    let showIcon: Bool

    public init(_ text: String, wordsPerMinute: Int = 200, showIcon: Bool = true) {
        self.text = text
        self.wordsPerMinute = max(1, wordsPerMinute)
        self.showIcon = showIcon
    }

    private var readingTime: Int {
        let words = text.split(separator: " ").count
        let minutes = max(1, words / wordsPerMinute)
        return minutes
    }

    public var body: some View {
        HStack(spacing: 4) {
            if showIcon {
                Image(systemName: "clock")
                    .font(.system(size: 12))
            }
            Text("\(readingTime) min read")
                .font(.system(size: 12))
        }
        .foregroundColor(.secondary)
    }
}

/// A text divider/separator with text in middle
public struct TextDivider: View {
    let text: String
    let color: Color

    public init(_ text: String, color: Color = .secondary) {
        self.text = text
        self.color = color
    }

    public var body: some View {
        HStack(spacing: 16) {
            Rectangle()
                .fill(color.opacity(0.3))
                .frame(height: 1)

            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(color)

            Rectangle()
                .fill(color.opacity(0.3))
                .frame(height: 1)
        }
    }
}

/// A label with optional required indicator
public struct FormLabel: View {
    let text: String
    let isRequired: Bool
    let hint: String?

    public init(_ text: String, isRequired: Bool = false, hint: String? = nil) {
        self.text = text
        self.isRequired = isRequired
        self.hint = hint
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Text(text)
                    .font(.system(size: 14, weight: .medium))

                if isRequired {
                    Text("*")
                        .foregroundColor(.red)
                }
            }

            if let hint = hint {
                Text(hint)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview("Text Components") {
    ScrollView {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Expandable Text")
                    .font(.headline)

                ExpandableText(
                    "SwiftUI lays out a view in three steps: the parent proposes a size, the child picks its own size, and the parent places the child. Text follows the same rule, so a long paragraph in a narrow column wraps onto more lines instead of widening the column. ExpandableText measures the paragraph twice, with and without the line limit, and shows the Read more button only when the limit cut something off."
                )
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Reading Time")
                    .font(.headline)

                ReadingTimeText("ReadingTimeText divides the word count by the reading speed, 200 words per minute unless you pass another value, and never shows less than one minute.")
            }

            Divider()

            VStack(spacing: 16) {
                Text("Text Dividers")
                    .font(.headline)

                TextDivider("OR")
                TextDivider("Continue with", color: .gray)
            }

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                Text("Form Labels")
                    .font(.headline)

                FormLabel("Email", isRequired: true)
                FormLabel("Password", isRequired: true, hint: "Must be at least 8 characters")
                FormLabel("Notes")
            }
        }
        .padding()
    }
}
