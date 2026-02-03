import SwiftUI

/// A versatile avatar component for user profiles.
///
/// `Avatar` displays user images, initials, or placeholder icons
/// with customizable shapes and sizes.
///
/// ```swift
/// Avatar(image: Image("profile"), size: .large)
/// Avatar(initials: "JD", color: .blue)
/// ```
public struct Avatar: View {
    // MARK: - Types
    
    /// The size of the avatar.
    public enum Size {
        case tiny
        case small
        case medium
        case large
        case extraLarge
        case custom(CGFloat)
        
        var dimension: CGFloat {
            switch self {
            case .tiny: return 24
            case .small: return 32
            case .medium: return 44
            case .large: return 64
            case .extraLarge: return 96
            case .custom(let size): return size
            }
        }
        
        var font: Font {
            switch self {
            case .tiny: return .system(size: 10, weight: .semibold)
            case .small: return .system(size: 12, weight: .semibold)
            case .medium: return .system(size: 16, weight: .semibold)
            case .large: return .system(size: 24, weight: .semibold)
            case .extraLarge: return .system(size: 36, weight: .semibold)
            case .custom(let size): return .system(size: size * 0.4, weight: .semibold)
            }
        }
    }
    
    /// The shape of the avatar.
    public enum Shape {
        case circle
        case rounded(CGFloat)
        case square
    }
    
    // MARK: - Properties
    
    private let image: Image?
    private let initials: String?
    private let systemIcon: String?
    private let size: Size
    private let shape: Shape
    private let backgroundColor: Color
    private let foregroundColor: Color
    private let borderColor: Color?
    private let borderWidth: CGFloat
    private let showOnlineIndicator: Bool
    private let isOnline: Bool
    
    // MARK: - Initialization
    
    /// Creates an avatar with an image.
    public init(
        image: Image,
        size: Size = .medium,
        shape: Shape = .circle,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0,
        showOnlineIndicator: Bool = false,
        isOnline: Bool = false
    ) {
        self.image = image
        self.initials = nil
        self.systemIcon = nil
        self.size = size
        self.shape = shape
        self.backgroundColor = .gray.opacity(0.2)
        self.foregroundColor = .white
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.showOnlineIndicator = showOnlineIndicator
        self.isOnline = isOnline
    }
    
    /// Creates an avatar with initials.
    public init(
        initials: String,
        size: Size = .medium,
        shape: Shape = .circle,
        backgroundColor: Color = .blue,
        foregroundColor: Color = .white,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0,
        showOnlineIndicator: Bool = false,
        isOnline: Bool = false
    ) {
        self.image = nil
        self.initials = String(initials.prefix(2)).uppercased()
        self.systemIcon = nil
        self.size = size
        self.shape = shape
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.showOnlineIndicator = showOnlineIndicator
        self.isOnline = isOnline
    }
    
    /// Creates an avatar with a system icon.
    public init(
        systemIcon: String = "person.fill",
        size: Size = .medium,
        shape: Shape = .circle,
        backgroundColor: Color = .gray.opacity(0.2),
        foregroundColor: Color = .gray,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0
    ) {
        self.image = nil
        self.initials = nil
        self.systemIcon = systemIcon
        self.size = size
        self.shape = shape
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.showOnlineIndicator = false
        self.isOnline = false
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            avatarContent
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(avatarShape)
                .overlay(borderOverlay)
            
            if showOnlineIndicator {
                onlineIndicator
            }
        }
    }
    
    // MARK: - Avatar Content
    
    @ViewBuilder
    private var avatarContent: some View {
        if let image {
            image
                .resizable()
                .scaledToFill()
        } else if let initials {
            ZStack {
                backgroundColor
                Text(initials)
                    .font(size.font)
                    .foregroundStyle(foregroundColor)
            }
        } else if let systemIcon {
            ZStack {
                backgroundColor
                Image(systemName: systemIcon)
                    .font(size.font)
                    .foregroundStyle(foregroundColor)
            }
        }
    }
    
    // MARK: - Avatar Shape
    
    @ViewBuilder
    private var avatarShape: some Shape {
        switch shape {
        case .circle:
            Circle()
        case .rounded(let radius):
            RoundedRectangle(cornerRadius: radius)
        case .square:
            Rectangle()
        }
    }
    
    // MARK: - Border Overlay
    
    @ViewBuilder
    private var borderOverlay: some View {
        if let borderColor, borderWidth > 0 {
            switch shape {
            case .circle:
                Circle()
                    .stroke(borderColor, lineWidth: borderWidth)
            case .rounded(let radius):
                RoundedRectangle(cornerRadius: radius)
                    .stroke(borderColor, lineWidth: borderWidth)
            case .square:
                Rectangle()
                    .stroke(borderColor, lineWidth: borderWidth)
            }
        }
    }
    
    // MARK: - Online Indicator
    
    private var onlineIndicator: some View {
        Circle()
            .fill(isOnline ? Color.green : Color.gray)
            .frame(width: size.dimension * 0.25, height: size.dimension * 0.25)
            .overlay(
                Circle()
                    .stroke(Color(.systemBackground), lineWidth: 2)
            )
    }
}

// MARK: - Avatar Group

/// Displays multiple avatars in an overlapping stack.
public struct AvatarGroup: View {
    private let avatars: [AvatarData]
    private let size: Avatar.Size
    private let maxVisible: Int
    private let overlapAmount: CGFloat
    
    public struct AvatarData: Identifiable {
        public let id = UUID()
        public let image: Image?
        public let initials: String?
        public let backgroundColor: Color
        
        public init(image: Image? = nil, initials: String? = nil, backgroundColor: Color = .blue) {
            self.image = image
            self.initials = initials
            self.backgroundColor = backgroundColor
        }
    }
    
    public init(
        avatars: [AvatarData],
        size: Avatar.Size = .small,
        maxVisible: Int = 4,
        overlapAmount: CGFloat = 0.3
    ) {
        self.avatars = avatars
        self.size = size
        self.maxVisible = maxVisible
        self.overlapAmount = overlapAmount
    }
    
    public var body: some View {
        HStack(spacing: -size.dimension * overlapAmount) {
            ForEach(Array(displayedAvatars.enumerated()), id: \.element.id) { index, data in
                if let image = data.image {
                    Avatar(image: image, size: size, borderColor: .white, borderWidth: 2)
                } else if let initials = data.initials {
                    Avatar(initials: initials, size: size, backgroundColor: data.backgroundColor, borderColor: .white, borderWidth: 2)
                } else {
                    Avatar(size: size, borderColor: .white, borderWidth: 2)
                }
            }
            
            if remainingCount > 0 {
                Avatar(
                    initials: "+\(remainingCount)",
                    size: size,
                    backgroundColor: .gray.opacity(0.3),
                    foregroundColor: .primary,
                    borderColor: .white,
                    borderWidth: 2
                )
            }
        }
    }
    
    private var displayedAvatars: [AvatarData] {
        Array(avatars.prefix(maxVisible))
    }
    
    private var remainingCount: Int {
        max(0, avatars.count - maxVisible)
    }
}

// MARK: - Editable Avatar

/// An avatar with an edit overlay button.
public struct EditableAvatar: View {
    @Binding private var image: Image?
    private let size: Avatar.Size
    private let initials: String
    private let onEdit: () -> Void
    
    public init(
        image: Binding<Image?>,
        size: Avatar.Size = .large,
        initials: String = "",
        onEdit: @escaping () -> Void
    ) {
        self._image = image
        self.size = size
        self.initials = initials
        self.onEdit = onEdit
    }
    
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let img = image {
                Avatar(image: img, size: size)
            } else if !initials.isEmpty {
                Avatar(initials: initials, size: size)
            } else {
                Avatar(size: size)
            }
            
            Button(action: onEdit) {
                Image(systemName: "camera.fill")
                    .font(.system(size: size.dimension * 0.2))
                    .foregroundStyle(.white)
                    .padding(size.dimension * 0.1)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color(.systemBackground), lineWidth: 2)
                    )
            }
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 30) {
        HStack(spacing: 16) {
            Avatar(initials: "JD", size: .small)
            Avatar(initials: "AB", size: .medium, backgroundColor: .green)
            Avatar(initials: "XY", size: .large, backgroundColor: .purple)
        }
        
        HStack(spacing: 16) {
            Avatar(size: .medium)
            Avatar(initials: "JD", size: .medium, showOnlineIndicator: true, isOnline: true)
            Avatar(initials: "AB", size: .medium, showOnlineIndicator: true, isOnline: false)
        }
        
        AvatarGroup(avatars: [
            .init(initials: "A", backgroundColor: .blue),
            .init(initials: "B", backgroundColor: .green),
            .init(initials: "C", backgroundColor: .orange),
            .init(initials: "D", backgroundColor: .purple),
            .init(initials: "E", backgroundColor: .pink),
            .init(initials: "F", backgroundColor: .red)
        ])
        
        EditableAvatar(image: .constant(nil), initials: "JD") { }
    }
    .padding()
}
#endif
