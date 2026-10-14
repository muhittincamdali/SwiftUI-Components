import SwiftUI

/// Text with highlighted search matches or custom highlights.
///
/// `HighlightedText` makes it easy to emphasize specific portions
/// of text with custom styling.
///
/// ```swift
/// HighlightedText(
///     "Hello World",
///     highlights: ["World"],
///     highlightColor: .yellow
/// )
/// ```
public struct HighlightedText: View {
    // MARK: - Types

    /// A highlight range with styling.
    public struct Highlight: Identifiable {
        public let id = UUID()
        public let text: String
        public let backgroundColor: Color
        public let foregroundColor: Color?
        public let font: Font?
        public let underline: Bool

        public init(
            text: String,
            backgroundColor: Color = .yellow.opacity(0.4),
            foregroundColor: Color? = nil,
            font: Font? = nil,
            underline: Bool = false
        ) {
            self.text = text
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
            self.font = font
            self.underline = underline
        }
    }

    // MARK: - Properties

    private let text: String
    private let highlights: [Highlight]
    private let caseSensitive: Bool
    private let baseFont: Font
    private let baseColor: Color

    // MARK: - Initialization

    /// Creates highlighted text with custom highlight definitions.
    public init(
        _ text: String,
        highlights: [Highlight],
        caseSensitive: Bool = false,
        baseFont: Font = .body,
        baseColor: Color = .primary
    ) {
        self.text = text
        self.highlights = highlights
        self.caseSensitive = caseSensitive
        self.baseFont = baseFont
        self.baseColor = baseColor
    }

    /// Convenience initializer for simple string highlights.
    public init(
        _ text: String,
        highlights: [String],
        highlightColor: Color = .yellow.opacity(0.4),
        caseSensitive: Bool = false,
        baseFont: Font = .body
    ) {
        self.text = text
        self.highlights = highlights.map { Highlight(text: $0, backgroundColor: highlightColor) }
        self.caseSensitive = caseSensitive
        self.baseFont = baseFont
        self.baseColor = .primary
    }

    // MARK: - Body

    public var body: some View {
        buildAttributedText()
            .font(baseFont)
            .foregroundStyle(baseColor)
    }

    // MARK: - Text Building

    private func buildAttributedText() -> Text {
        guard !highlights.isEmpty else {
            return Text(text)
        }

        var attributed = AttributedString(text)
        let matches = Self.matchRanges(in: text, terms: highlights.map(\.text), caseSensitive: caseSensitive)

        for match in matches {
            let highlight = highlights[match.termIndex]
            guard let lower = AttributedString.Index(match.range.lowerBound, within: attributed),
                  let upper = AttributedString.Index(match.range.upperBound, within: attributed) else {
                continue
            }
            let range = lower..<upper
            attributed[range].backgroundColor = highlight.backgroundColor
            if let color = highlight.foregroundColor {
                attributed[range].foregroundColor = color
            }
            if let font = highlight.font {
                attributed[range].font = font
            }
            if highlight.underline {
                attributed[range].underlineStyle = .single
            }
        }

        return Text(attributed)
    }

    /// Finds every occurrence of `terms` in `text`, sorted by position.
    ///
    /// Empty terms are ignored. When matches overlap, the one that starts first wins
    /// (ties go to the longer match) so no character is highlighted twice.
    /// - Returns: Matched ranges in `text` together with the index of the term that produced them.
    public nonisolated static func matchRanges(
        in text: String,
        terms: [String],
        caseSensitive: Bool
    ) -> [(range: Range<String.Index>, termIndex: Int)] {
        let options: String.CompareOptions = caseSensitive ? [] : [.caseInsensitive]
        var candidates: [(range: Range<String.Index>, termIndex: Int)] = []

        for (termIndex, term) in terms.enumerated() where !term.isEmpty {
            var searchStart = text.startIndex
            while searchStart < text.endIndex,
                  let found = text.range(of: term, options: options, range: searchStart..<text.endIndex) {
                candidates.append((found, termIndex))
                searchStart = found.upperBound
            }
        }

        candidates.sort {
            if $0.range.lowerBound != $1.range.lowerBound {
                return $0.range.lowerBound < $1.range.lowerBound
            }
            return $0.range.upperBound > $1.range.upperBound
        }

        var result: [(range: Range<String.Index>, termIndex: Int)] = []
        for candidate in candidates {
            if let last = result.last, candidate.range.lowerBound < last.range.upperBound {
                continue
            }
            result.append(candidate)
        }
        return result
    }
}

// MARK: - Search Highlighted Text

/// Text view optimized for search result highlighting.
public struct SearchHighlightedText: View {
    private let text: String
    private let searchQuery: String
    private let highlightColor: Color
    private let font: Font

    public init(
        _ text: String,
        searchQuery: String,
        highlightColor: Color = .yellow.opacity(0.5),
        font: Font = .body
    ) {
        self.text = text
        self.searchQuery = searchQuery
        self.highlightColor = highlightColor
        self.font = font
    }

    public var body: some View {
        if searchQuery.isEmpty {
            Text(text)
                .font(font)
        } else {
            HighlightedText(
                text,
                highlights: [searchQuery],
                highlightColor: highlightColor,
                caseSensitive: false,
                baseFont: font
            )
        }
    }
}

// MARK: - Mention Text

/// Text with highlighted mentions (e.g., @username, #hashtag).
public struct MentionText: View {
    private let text: String
    private let mentionColor: Color
    private let hashtagColor: Color
    private let linkColor: Color
    private let font: Font
    private let onMentionTap: ((String) -> Void)?
    private let onHashtagTap: ((String) -> Void)?

    public init(
        _ text: String,
        mentionColor: Color = .blue,
        hashtagColor: Color = .purple,
        linkColor: Color = .blue,
        font: Font = .body,
        onMentionTap: ((String) -> Void)? = nil,
        onHashtagTap: ((String) -> Void)? = nil
    ) {
        self.text = text
        self.mentionColor = mentionColor
        self.hashtagColor = hashtagColor
        self.linkColor = linkColor
        self.font = font
        self.onMentionTap = onMentionTap
        self.onHashtagTap = onHashtagTap
    }

    public var body: some View {
        buildText()
            .font(font)
    }

    private func buildText() -> Text {
        var result = Text("")
        let words = text.components(separatedBy: " ")

        for (index, word) in words.enumerated() {
            let separator = index > 0 ? Text(" ") : Text("")

            if word.hasPrefix("@") && word.count > 1 {
                result = result + separator + Text(word).foregroundColor(mentionColor).fontWeight(.medium)
            } else if word.hasPrefix("#") && word.count > 1 {
                result = result + separator + Text(word).foregroundColor(hashtagColor).fontWeight(.medium)
            } else {
                result = result + separator + Text(word)
            }
        }

        return result
    }
}

// MARK: - Attributed Markdown Text

/// Simple markdown-style text rendering.
public struct SimpleMarkdownText: View {
    private let text: String
    private let font: Font

    public init(_ text: String, font: Font = .body) {
        self.text = text
        self.font = font
    }

    public var body: some View {
        if #available(iOS 15.0, *) {
            Text(try! AttributedString(markdown: text))
                .font(font)
        } else {
            Text(text)
                .font(font)
        }
    }
}

#if DEBUG
#Preview {
    VStack(alignment: .leading, spacing: 20) {
        HighlightedText(
            "The quick brown fox jumps over the lazy dog",
            highlights: ["quick", "fox", "dog"],
            highlightColor: .yellow.opacity(0.5)
        )

        HighlightedText(
            "SwiftUI is amazing!",
            highlights: [
                .init(text: "SwiftUI", backgroundColor: .blue.opacity(0.3), foregroundColor: .blue, font: .headline),
                .init(text: "amazing", backgroundColor: .green.opacity(0.3), underline: true)
            ]
        )

        SearchHighlightedText(
            "Search results for: SwiftUI components library",
            searchQuery: "swiftui",
            highlightColor: .orange.opacity(0.4)
        )

        MentionText(
            "Hey @mayachen check out #SwiftUI #iOS",
            mentionColor: .blue,
            hashtagColor: .purple
        )

        SimpleMarkdownText("This is **bold** and *italic* text")
    }
    .padding()
}
#endif
