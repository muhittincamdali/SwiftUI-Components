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
    @State private var isTruncated = false
    
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
                .background(
                    // Measure if text is truncated
                    GeometryReader { geometry in
                        Color.clear.onAppear {
                            let totalHeight = text.height(withConstrainedWidth: geometry.size.width, font: UIFont.preferredFont(forTextStyle: .body))
                            let lineHeight = UIFont.preferredFont(forTextStyle: .body).lineHeight
                            isTruncated = totalHeight > lineHeight * CGFloat(lineLimit)
                        }
                    }
                )
            
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
        self.wordsPerMinute = wordsPerMinute
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

// Helper extension
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}

#Preview("Text Components") {
    ScrollView {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Expandable Text")
                    .font(.headline)
                
                ExpandableText(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
                )
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Reading Time")
                    .font(.headline)
                
                ReadingTimeText("This is a sample article text that would take some time to read.")
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
