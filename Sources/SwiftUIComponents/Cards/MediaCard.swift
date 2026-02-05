import SwiftUI

/// A card for displaying media content (images, videos, articles)
public struct MediaCard: View {
    let title: String
    let subtitle: String?
    let duration: String?
    let category: String?
    let imageURL: URL?
    let style: MediaCardStyle
    let mediaType: MediaType
    let onPlay: (() -> Void)?
    let onTap: (() -> Void)?
    
    public enum MediaCardStyle {
        case standard
        case overlay
        case horizontal
        case playlist
    }
    
    public enum MediaType {
        case video
        case article
        case podcast
        case music
        case image
    }
    
    public init(
        title: String,
        subtitle: String? = nil,
        duration: String? = nil,
        category: String? = nil,
        imageURL: URL? = nil,
        style: MediaCardStyle = .standard,
        mediaType: MediaType = .video,
        onPlay: (() -> Void)? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.duration = duration
        self.category = category
        self.imageURL = imageURL
        self.style = style
        self.mediaType = mediaType
        self.onPlay = onPlay
        self.onTap = onTap
    }
    
    public var body: some View {
        Group {
            switch style {
            case .standard:
                standardView
            case .overlay:
                overlayView
            case .horizontal:
                horizontalView
            case .playlist:
                playlistView
            }
        }
        .onTapGesture { onTap?() }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(mediaType) \(title)")
    }
    
    private var mediaIcon: String {
        switch mediaType {
        case .video: return "play.fill"
        case .article: return "doc.text.fill"
        case .podcast: return "mic.fill"
        case .music: return "music.note"
        case .image: return "photo.fill"
        }
    }
    
    private var imagePlaceholder: some View {
        ZStack {
            LinearGradient(
                colors: [.purple.opacity(0.6), .blue.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            Image(systemName: mediaIcon)
                .font(.system(size: 30))
                .foregroundColor(.white.opacity(0.5))
        }
    }
    
    @ViewBuilder
    private var playButton: some View {
        if mediaType == .video || mediaType == .podcast || mediaType == .music {
            Button(action: { onPlay?() }) {
                Image(systemName: "play.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
        }
    }
    
    @ViewBuilder
    private var durationBadge: some View {
        if let duration = duration {
            Text(duration)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.7))
                .cornerRadius(4)
        }
    }
    
    private var standardView: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                imagePlaceholder
                    .aspectRatio(16/9, contentMode: .fill)
                    .frame(height: 180)
                    .clipped()
                
                playButton
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        durationBadge
                            .padding(8)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                if let category = category {
                    Text(category.uppercased())
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.accentColor)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(2)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            .padding(12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
    
    private var overlayView: some View {
        ZStack(alignment: .bottom) {
            imagePlaceholder
                .aspectRatio(16/9, contentMode: .fill)
                .frame(height: 220)
                .clipped()
            
            // Gradient overlay
            LinearGradient(
                colors: [.clear, .black.opacity(0.8)],
                startPoint: .center,
                endPoint: .bottom
            )
            
            // Play button centered
            playButton
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    if let category = category {
                        Text(category.uppercased())
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.accentColor)
                    }
                    Spacer()
                    durationBadge
                }
                
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(16)
        }
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
    }
    
    private var horizontalView: some View {
        HStack(spacing: 12) {
            ZStack {
                imagePlaceholder
                    .frame(width: 140, height: 90)
                    .cornerRadius(8)
                
                playButton
                    .scaleEffect(0.7)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        durationBadge
                            .padding(4)
                    }
                }
            }
            .frame(width: 140, height: 90)
            
            VStack(alignment: .leading, spacing: 6) {
                if let category = category {
                    Text(category.uppercased())
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.accentColor)
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(2)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var playlistView: some View {
        HStack(spacing: 12) {
            imagePlaceholder
                .frame(width: 56, height: 56)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            if let duration = duration {
                Text(duration)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Button(action: { onPlay?() }) {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.accentColor)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
    }
}

#Preview("Media Cards") {
    ScrollView {
        VStack(spacing: 20) {
            MediaCard(
                title: "SwiftUI Tutorial: Building a Complete App",
                subtitle: "Learn iOS Development",
                duration: "15:30",
                category: "Tutorial",
                style: .standard,
                mediaType: .video,
                onPlay: {}
            )
            
            MediaCard(
                title: "The Future of iOS Development",
                subtitle: "Tech Talk Conference 2024",
                duration: "45:00",
                category: "Conference",
                style: .overlay,
                mediaType: .video,
                onPlay: {}
            )
            
            MediaCard(
                title: "Understanding Swift Concurrency",
                subtitle: "Podcast Episode #42",
                duration: "32:15",
                style: .horizontal,
                mediaType: .podcast,
                onPlay: {}
            )
            
            VStack(spacing: 0) {
                MediaCard(
                    title: "Track 1 - Introduction",
                    subtitle: "Album Name",
                    duration: "3:45",
                    style: .playlist,
                    mediaType: .music,
                    onPlay: {}
                )
                Divider().padding(.leading, 80)
                MediaCard(
                    title: "Track 2 - Main Theme",
                    subtitle: "Album Name",
                    duration: "4:20",
                    style: .playlist,
                    mediaType: .music,
                    onPlay: {}
                )
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
        .padding()
    }
    .background(Color(.systemGray6))
}
