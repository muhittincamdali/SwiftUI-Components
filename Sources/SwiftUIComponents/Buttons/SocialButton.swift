import SwiftUI

/// Buttons styled for social media login/actions
public struct SocialButton: View {
    let provider: SocialProvider
    let title: String?
    let action: () -> Void
    let style: SocialStyle
    
    public enum SocialProvider: CaseIterable {
        case apple
        case google
        case facebook
        case twitter
        case github
        case linkedin
        
        var icon: String {
            switch self {
            case .apple: return "apple.logo"
            case .google: return "g.circle.fill"
            case .facebook: return "f.circle.fill"
            case .twitter: return "bird"
            case .github: return "chevron.left.forwardslash.chevron.right"
            case .linkedin: return "link"
            }
        }
        
        var color: Color {
            switch self {
            case .apple: return .primary
            case .google: return Color(red: 0.92, green: 0.26, blue: 0.21)
            case .facebook: return Color(red: 0.23, green: 0.35, blue: 0.60)
            case .twitter: return Color(red: 0.11, green: 0.63, blue: 0.95)
            case .github: return Color(red: 0.14, green: 0.14, blue: 0.16)
            case .linkedin: return Color(red: 0.0, green: 0.47, blue: 0.71)
            }
        }
        
        var name: String {
            switch self {
            case .apple: return "Apple"
            case .google: return "Google"
            case .facebook: return "Facebook"
            case .twitter: return "Twitter"
            case .github: return "GitHub"
            case .linkedin: return "LinkedIn"
            }
        }
    }
    
    public enum SocialStyle {
        case filled
        case outlined
        case iconOnly
    }
    
    public init(
        _ provider: SocialProvider,
        title: String? = nil,
        style: SocialStyle = .filled,
        action: @escaping () -> Void
    ) {
        self.provider = provider
        self.title = title
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: provider.icon)
                    .font(.system(size: 20))
                
                if style != .iconOnly {
                    Text(title ?? "Continue with \(provider.name)")
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(foregroundColor)
            .padding(.horizontal, style == .iconOnly ? 16 : 24)
            .padding(.vertical, 14)
            .frame(maxWidth: style == .iconOnly ? nil : .infinity)
            .background(background)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("Sign in with \(provider.name)")
        .accessibilityAddTraits(.isButton)
    }
    
    private var foregroundColor: Color {
        switch style {
        case .filled: return .white
        case .outlined, .iconOnly: return provider.color
        }
    }
    
    @ViewBuilder
    private var background: some View {
        switch style {
        case .filled:
            RoundedRectangle(cornerRadius: 12)
                .fill(provider.color)
        case .outlined:
            RoundedRectangle(cornerRadius: 12)
                .stroke(provider.color, lineWidth: 2)
        case .iconOnly:
            Circle()
                .fill(provider.color.opacity(0.1))
        }
    }
}

#Preview("Social Buttons") {
    VStack(spacing: 16) {
        SocialButton(.apple) {}
        SocialButton(.google) {}
        SocialButton(.facebook, style: .outlined) {}
        
        HStack(spacing: 12) {
            ForEach(SocialButton.SocialProvider.allCases, id: \.self) { provider in
                SocialButton(provider, style: .iconOnly) {}
            }
        }
    }
    .padding()
}
