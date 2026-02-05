import SwiftUI

/// A styled quote/blockquote component
public struct QuoteView: View {
    let text: String
    let author: String?
    let source: String?
    let style: QuoteStyle
    let color: Color
    
    public enum QuoteStyle {
        case standard
        case leftBorder
        case centered
        case card
        case minimal
    }
    
    public init(
        text: String,
        author: String? = nil,
        source: String? = nil,
        style: QuoteStyle = .standard,
        color: Color = .accentColor
    ) {
        self.text = text
        self.author = author
        self.source = source
        self.style = style
        self.color = color
    }
    
    public var body: some View {
        Group {
            switch style {
            case .standard:
                standardView
            case .leftBorder:
                leftBorderView
            case .centered:
                centeredView
            case .card:
                cardView
            case .minimal:
                minimalView
            }
        }
    }
    
    private var standardView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: "quote.opening")
                    .font(.system(size: 24))
                    .foregroundColor(color.opacity(0.5))
                
                Text(text)
                    .font(.system(size: 16))
                    .italic()
                    .foregroundColor(.primary.opacity(0.9))
            }
            
            if author != nil || source != nil {
                HStack(spacing: 4) {
                    Text("—")
                    if let author = author {
                        Text(author)
                            .fontWeight(.medium)
                    }
                    if let source = source {
                        Text("(\(source))")
                            .foregroundColor(.secondary)
                    }
                }
                .font(.system(size: 14))
                .padding(.leading, 32)
            }
        }
    }
    
    private var leftBorderView: some View {
        HStack(spacing: 16) {
            Rectangle()
                .fill(color)
                .frame(width: 4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(text)
                    .font(.system(size: 16))
                    .italic()
                    .foregroundColor(.primary.opacity(0.9))
                
                if author != nil || source != nil {
                    HStack(spacing: 4) {
                        if let author = author {
                            Text(author)
                                .fontWeight(.medium)
                        }
                        if let source = source {
                            Text("• \(source)")
                                .foregroundColor(.secondary)
                        }
                    }
                    .font(.system(size: 13))
                }
            }
        }
        .padding(.vertical, 12)
    }
    
    private var centeredView: some View {
        VStack(spacing: 16) {
            Image(systemName: "quote.opening")
                .font(.system(size: 32))
                .foregroundColor(color.opacity(0.4))
            
            Text(text)
                .font(.system(size: 18))
                .italic()
                .multilineTextAlignment(.center)
                .foregroundColor(.primary.opacity(0.9))
            
            if author != nil || source != nil {
                VStack(spacing: 4) {
                    if let author = author {
                        Text(author)
                            .font(.system(size: 14, weight: .semibold))
                    }
                    if let source = source {
                        Text(source)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(24)
    }
    
    private var cardView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "quote.opening")
                    .font(.system(size: 20))
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(text)
                .font(.system(size: 15))
                .italic()
                .foregroundColor(.primary.opacity(0.9))
            
            if author != nil || source != nil {
                HStack(spacing: 8) {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Text(String(author?.prefix(1) ?? "Q"))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(color)
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        if let author = author {
                            Text(author)
                                .font(.system(size: 13, weight: .medium))
                        }
                        if let source = source {
                            Text(source)
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
    
    private var minimalView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\"\(text)\"")
                .font(.system(size: 15))
                .foregroundColor(.primary.opacity(0.85))
            
            if let author = author {
                Text("— \(author)")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
        }
    }
}

/// A callout/highlight box
public struct CalloutView: View {
    let title: String?
    let message: String
    let icon: String?
    let type: CalloutType
    
    public enum CalloutType {
        case info
        case success
        case warning
        case error
        case tip
        case note
        
        var color: Color {
            switch self {
            case .info: return .blue
            case .success: return .green
            case .warning: return .orange
            case .error: return .red
            case .tip: return .purple
            case .note: return .gray
            }
        }
        
        var defaultIcon: String {
            switch self {
            case .info: return "info.circle.fill"
            case .success: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .error: return "xmark.circle.fill"
            case .tip: return "lightbulb.fill"
            case .note: return "note.text"
            }
        }
    }
    
    public init(
        title: String? = nil,
        message: String,
        icon: String? = nil,
        type: CalloutType = .info
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.type = type
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon ?? type.defaultIcon)
                .font(.system(size: 20))
                .foregroundColor(type.color)
            
            VStack(alignment: .leading, spacing: 4) {
                if let title = title {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                }
                
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.primary.opacity(0.85))
            }
            
            Spacer()
        }
        .padding(16)
        .background(type.color.opacity(0.1))
        .overlay(
            Rectangle()
                .fill(type.color)
                .frame(width: 4),
            alignment: .leading
        )
        .cornerRadius(8)
    }
}

#Preview("Quote & Callout") {
    ScrollView {
        VStack(spacing: 24) {
            QuoteView(
                text: "The only way to do great work is to love what you do.",
                author: "Steve Jobs",
                source: "Stanford Commencement",
                style: .standard
            )
            
            QuoteView(
                text: "Innovation distinguishes between a leader and a follower.",
                author: "Steve Jobs",
                style: .leftBorder,
                color: .blue
            )
            
            QuoteView(
                text: "Stay hungry, stay foolish.",
                author: "Steve Jobs",
                style: .centered,
                color: .purple
            )
            
            QuoteView(
                text: "Design is not just what it looks like and feels like. Design is how it works.",
                author: "Steve Jobs",
                source: "Apple",
                style: .card
            )
            
            Divider()
            
            CalloutView(
                title: "Information",
                message: "This is an informational callout to provide helpful context.",
                type: .info
            )
            
            CalloutView(
                title: "Success",
                message: "Your changes have been saved successfully!",
                type: .success
            )
            
            CalloutView(
                title: "Warning",
                message: "Please backup your data before continuing.",
                type: .warning
            )
            
            CalloutView(
                title: "Pro Tip",
                message: "You can use keyboard shortcuts for faster navigation.",
                type: .tip
            )
        }
        .padding()
    }
}
