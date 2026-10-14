import SwiftUI

/// A customizable star rating input component.
///
/// `RatingInput` provides an intuitive way to collect user ratings
/// with support for half-stars and custom symbols.
///
/// ```swift
/// RatingInput(rating: $rating, maxRating: 5)
/// ```
public struct RatingInput: View {
    // MARK: - Types
    
    /// The rating precision mode.
    public enum Precision {
        case full
        case half
        case exact
    }
    
    /// The symbol style for rating.
    public enum SymbolStyle {
        case star
        case heart
        case circle
        case custom(filled: Image, empty: Image)
        
        var filledImage: Image {
            switch self {
            case .star: return Image(systemName: "star.fill")
            case .heart: return Image(systemName: "heart.fill")
            case .circle: return Image(systemName: "circle.fill")
            case .custom(let filled, _): return filled
            }
        }
        
        var emptyImage: Image {
            switch self {
            case .star: return Image(systemName: "star")
            case .heart: return Image(systemName: "heart")
            case .circle: return Image(systemName: "circle")
            case .custom(_, let empty): return empty
            }
        }
        
        var halfImage: Image {
            switch self {
            case .star: return Image(systemName: "star.leadinghalf.filled")
            case .heart: return Image(systemName: "heart.fill")
            case .circle: return Image(systemName: "circle.lefthalf.filled")
            case .custom(let filled, _): return filled
            }
        }
    }
    
    // MARK: - Properties
    
    @Binding private var rating: Double
    private let maxRating: Int
    private let precision: Precision
    private let symbolStyle: SymbolStyle
    private let filledColor: Color
    private let emptyColor: Color
    private let size: CGFloat
    private let spacing: CGFloat
    private let isInteractive: Bool
    private let animation: Animation?
    private let onRatingChanged: ((Double) -> Void)?
    
    @State private var hoverRating: Double?
    
    // MARK: - Initialization
    
    /// Creates a new rating input.
    /// - Parameters:
    ///   - rating: Binding to the current rating value.
    ///   - maxRating: Maximum rating value. Defaults to `5`.
    ///   - precision: Rating precision. Defaults to `.full`.
    ///   - symbolStyle: The symbol style. Defaults to `.star`.
    ///   - filledColor: Color for filled symbols. Defaults to `.yellow`.
    ///   - emptyColor: Color for empty symbols. Defaults to `.gray.opacity(0.3)`.
    ///   - size: Symbol size. Defaults to `24`.
    ///   - spacing: Space between symbols. Defaults to `4`.
    ///   - isInteractive: Whether user can change rating. Defaults to `true`.
    ///   - animation: Animation for rating changes. Defaults to `.easeInOut`.
    ///   - onRatingChanged: Callback when rating changes. Defaults to `nil`.
    public init(
        rating: Binding<Double>,
        maxRating: Int = 5,
        precision: Precision = .full,
        symbolStyle: SymbolStyle = .star,
        filledColor: Color = .yellow,
        emptyColor: Color = .gray.opacity(0.3),
        size: CGFloat = 24,
        spacing: CGFloat = 4,
        isInteractive: Bool = true,
        animation: Animation? = .easeInOut(duration: 0.15),
        onRatingChanged: ((Double) -> Void)? = nil
    ) {
        self._rating = rating
        self.maxRating = maxRating
        self.precision = precision
        self.symbolStyle = symbolStyle
        self.filledColor = filledColor
        self.emptyColor = emptyColor
        self.size = size
        self.spacing = spacing
        self.isInteractive = isInteractive
        self.animation = animation
        self.onRatingChanged = onRatingChanged
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(1...maxRating, id: \.self) { index in
                ratingSymbol(for: index)
                    .onTapGesture {
                        guard isInteractive else { return }
                        setRating(Double(index))
                    }
            }
        }
        .gesture(
            isInteractive ? dragGesture : nil
        )
        .animation(animation, value: rating)
    }
    
    // MARK: - Rating Symbol
    
    @ViewBuilder
    private func ratingSymbol(for index: Int) -> some View {
        let displayRating = hoverRating ?? rating
        let fillAmount = fillAmount(for: index, rating: displayRating)
        
        ZStack {
            symbolStyle.emptyImage
                .resizable()
                .scaledToFit()
                .foregroundStyle(emptyColor)
            
            if fillAmount > 0 {
                if fillAmount >= 1 {
                    symbolStyle.filledImage
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(filledColor)
                } else if precision == .half && fillAmount >= 0.5 {
                    symbolStyle.halfImage
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(filledColor)
                } else if precision == .exact {
                    symbolStyle.filledImage
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(filledColor)
                        .mask(
                            GeometryReader { geometry in
                                Rectangle()
                                    .frame(width: geometry.size.width * fillAmount)
                            }
                        )
                }
            }
        }
        .frame(width: size, height: size)
    }
    
    private func fillAmount(for index: Int, rating: Double) -> Double {
        if rating >= Double(index) {
            return 1
        } else if rating > Double(index - 1) {
            return rating - Double(index - 1)
        } else {
            return 0
        }
    }
    
    // MARK: - Gestures
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let starWidth = size + spacing
                let totalWidth = starWidth * CGFloat(maxRating) - spacing
                let x = max(0, min(value.location.x, totalWidth))
                
                var newRating = (x / starWidth) + 0.5
                
                switch precision {
                case .full:
                    newRating = round(newRating)
                case .half:
                    newRating = round(newRating * 2) / 2
                case .exact:
                    break
                }
                
                newRating = max(0, min(Double(maxRating), newRating))
                hoverRating = newRating
            }
            .onEnded { _ in
                if let hover = hoverRating {
                    setRating(hover)
                }
                hoverRating = nil
            }
    }
    
    // MARK: - Helpers
    
    private func setRating(_ newRating: Double) {
        rating = newRating
        onRatingChanged?(newRating)
    }
}

// MARK: - Display-Only Rating

/// A non-interactive rating display view.
public struct RatingDisplay: View {
    private let rating: Double
    private let maxRating: Int
    private let size: CGFloat
    private let filledColor: Color
    private let showValue: Bool
    
    public init(
        rating: Double,
        maxRating: Int = 5,
        size: CGFloat = 16,
        filledColor: Color = .yellow,
        showValue: Bool = false
    ) {
        self.rating = rating
        self.maxRating = maxRating
        self.size = size
        self.filledColor = filledColor
        self.showValue = showValue
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            RatingInput(
                rating: .constant(rating),
                maxRating: maxRating,
                precision: .exact,
                size: size,
                isInteractive: false
            )
            
            if showValue {
                Text(String(format: "%.1f", rating))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Emoji Rating

/// A rating input using emoji faces.
public struct EmojiRatingInput: View {
    @Binding var rating: Int
    
    private let emojis: [String]
    private let size: CGFloat
    private let labels: [String]?
    
    public init(
        rating: Binding<Int>,
        emojis: [String] = ["😢", "😕", "😐", "🙂", "😄"],
        size: CGFloat = 40,
        labels: [String]? = nil
    ) {
        self._rating = rating
        self.emojis = emojis
        self.size = size
        self.labels = labels
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                ForEach(0..<emojis.count, id: \.self) { index in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            rating = index + 1
                        }
                    } label: {
                        Text(emojis[index])
                            .font(.system(size: size))
                            .scaleEffect(rating == index + 1 ? 1.2 : 0.9)
                            .opacity(rating == 0 || rating == index + 1 ? 1 : 0.4)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            if let labels, rating > 0 && rating <= labels.count {
                Text(labels[rating - 1])
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .transition(.opacity)
            }
        }
    }
}

// MARK: - Slider Rating

/// A slider-based rating input.
public struct SliderRatingInput: View {
    @Binding var rating: Double
    
    private let range: ClosedRange<Double>
    private let step: Double
    private let showValue: Bool
    private let filledColor: Color
    
    public init(
        rating: Binding<Double>,
        range: ClosedRange<Double> = 0...10,
        step: Double = 0.5,
        showValue: Bool = true,
        filledColor: Color = .blue
    ) {
        self._rating = rating
        self.range = range
        self.step = step
        self.showValue = showValue
        self.filledColor = filledColor
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            Slider(value: $rating, in: range, step: step)
                .tint(filledColor)
            
            if showValue {
                HStack {
                    Text(String(format: "%.1f", range.lowerBound))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text(String(format: "%.1f", rating))
                        .font(.headline)
                        .foregroundStyle(filledColor)
                    
                    Spacer()
                    
                    Text(String(format: "%.1f", range.upperBound))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#if DEBUG
struct RatingInputPreview: View {
    @State private var rating1: Double = 3.5
    @State private var rating2: Double = 4.0
    @State private var rating3: Double = 2.5
    @State private var emojiRating: Int = 0
    @State private var sliderRating: Double = 7.5
    
    var body: some View {
        VStack(spacing: 30) {
            VStack {
                Text("Standard Rating")
                    .font(.caption)
                RatingInput(rating: $rating1)
            }
            
            VStack {
                Text("Half Precision + Hearts")
                    .font(.caption)
                RatingInput(
                    rating: $rating2,
                    precision: .half,
                    symbolStyle: .heart,
                    filledColor: .red,
                    size: 32
                )
            }
            
            VStack {
                Text("Exact Precision")
                    .font(.caption)
                RatingInput(
                    rating: $rating3,
                    precision: .exact,
                    filledColor: .orange
                )
            }
            
            VStack {
                Text("Display Only")
                    .font(.caption)
                RatingDisplay(rating: 4.3, showValue: true)
            }
            
            VStack {
                Text("Emoji Rating")
                    .font(.caption)
                EmojiRatingInput(
                    rating: $emojiRating,
                    labels: ["Terrible", "Bad", "Okay", "Good", "Great"]
                )
            }
            
            VStack {
                Text("Slider Rating")
                    .font(.caption)
                SliderRatingInput(rating: $sliderRating)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    RatingInputPreview()
}
#endif
