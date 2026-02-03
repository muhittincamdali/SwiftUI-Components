import SwiftUI

/// A card that flips between front and back content with 3D animation.
///
/// Use `FlipCard` to create interactive cards that reveal information
/// on tap or through binding control.
///
/// ```swift
/// FlipCard(isFlipped: $isFlipped) {
///     Text("Front Content")
/// } back: {
///     Text("Back Content")
/// }
/// ```
public struct FlipCard<Front: View, Back: View>: View {
    // MARK: - Types
    
    /// The axis around which the card flips.
    public enum FlipAxis {
        case horizontal
        case vertical
        
        var axis: (x: CGFloat, y: CGFloat, z: CGFloat) {
            switch self {
            case .horizontal: return (0, 1, 0)
            case .vertical: return (1, 0, 0)
            }
        }
    }
    
    /// The direction of the flip animation.
    public enum FlipDirection {
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
    }
    
    // MARK: - Properties
    
    @Binding private var isFlipped: Bool
    private let axis: FlipAxis
    private let duration: Double
    private let perspective: CGFloat
    private let tapToFlip: Bool
    private let cornerRadius: CGFloat
    private let shadowRadius: CGFloat
    private let shadowColor: Color
    private let frontContent: () -> Front
    private let backContent: () -> Back
    
    @State private var rotation: Double = 0
    @State private var animating: Bool = false
    
    // MARK: - Initialization
    
    /// Creates a new flip card.
    /// - Parameters:
    ///   - isFlipped: Binding to control flip state.
    ///   - axis: The flip axis. Defaults to `.horizontal`.
    ///   - duration: Animation duration. Defaults to `0.6`.
    ///   - perspective: 3D perspective amount. Defaults to `0.5`.
    ///   - tapToFlip: Whether tapping flips the card. Defaults to `true`.
    ///   - cornerRadius: Corner radius. Defaults to `16`.
    ///   - shadowRadius: Shadow radius. Defaults to `8`.
    ///   - shadowColor: Shadow color. Defaults to `.black.opacity(0.2)`.
    ///   - front: The front face content.
    ///   - back: The back face content.
    public init(
        isFlipped: Binding<Bool>,
        axis: FlipAxis = .horizontal,
        duration: Double = 0.6,
        perspective: CGFloat = 0.5,
        tapToFlip: Bool = true,
        cornerRadius: CGFloat = 16,
        shadowRadius: CGFloat = 8,
        shadowColor: Color = .black.opacity(0.2),
        @ViewBuilder front: @escaping () -> Front,
        @ViewBuilder back: @escaping () -> Back
    ) {
        self._isFlipped = isFlipped
        self.axis = axis
        self.duration = duration
        self.perspective = perspective
        self.tapToFlip = tapToFlip
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
        self.frontContent = front
        self.backContent = back
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            // Front side
            frontContent()
                .opacity(rotation < 90 ? 1 : 0)
                .rotation3DEffect(
                    .degrees(rotation),
                    axis: axis.axis,
                    perspective: perspective
                )
            
            // Back side (pre-rotated 180 degrees)
            backContent()
                .opacity(rotation >= 90 ? 1 : 0)
                .rotation3DEffect(
                    .degrees(rotation - 180),
                    axis: axis.axis,
                    perspective: perspective
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 4)
        .onTapGesture {
            guard tapToFlip && !animating else { return }
            isFlipped.toggle()
        }
        .onChange(of: isFlipped) { _, newValue in
            flip(to: newValue)
        }
    }
    
    // MARK: - Animation
    
    private func flip(to flipped: Bool) {
        guard !animating else { return }
        animating = true
        
        withAnimation(.easeInOut(duration: duration)) {
            rotation = flipped ? 180 : 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            animating = false
        }
    }
}

// MARK: - Flip Card View Modifier

/// A view modifier that wraps content in a flip card.
public struct FlipCardModifier<Back: View>: ViewModifier {
    @Binding var isFlipped: Bool
    let axis: FlipCard<AnyView, Back>.FlipAxis
    let duration: Double
    let back: () -> Back
    
    public func body(content: Content) -> some View {
        FlipCard(
            isFlipped: $isFlipped,
            axis: axis,
            duration: duration
        ) {
            content
        } back: {
            back()
        }
    }
}

extension View {
    /// Makes the view flippable to reveal back content.
    public func flippable<Back: View>(
        isFlipped: Binding<Bool>,
        axis: FlipCard<AnyView, Back>.FlipAxis = .horizontal,
        duration: Double = 0.6,
        @ViewBuilder back: @escaping () -> Back
    ) -> some View {
        modifier(FlipCardModifier(isFlipped: isFlipped, axis: axis, duration: duration, back: back))
    }
}

// MARK: - Credit Card Style

/// A pre-styled flip card designed for credit card displays.
public struct CreditCardFlipCard: View {
    @Binding var isFlipped: Bool
    
    let cardNumber: String
    let cardHolder: String
    let expiryDate: String
    let cvv: String
    let brandLogo: Image?
    let gradient: LinearGradient
    
    /// Creates a credit card style flip card.
    public init(
        isFlipped: Binding<Bool>,
        cardNumber: String,
        cardHolder: String,
        expiryDate: String,
        cvv: String,
        brandLogo: Image? = nil,
        gradient: LinearGradient = LinearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    ) {
        self._isFlipped = isFlipped
        self.cardNumber = cardNumber
        self.cardHolder = cardHolder
        self.expiryDate = expiryDate
        self.cvv = cvv
        self.brandLogo = brandLogo
        self.gradient = gradient
    }
    
    public var body: some View {
        FlipCard(isFlipped: $isFlipped) {
            // Front
            ZStack(alignment: .bottomLeading) {
                gradient
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Spacer()
                        brandLogo?
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                    
                    Spacer()
                    
                    Text(formatCardNumber(cardNumber))
                        .font(.system(size: 22, weight: .medium, design: .monospaced))
                        .foregroundStyle(.white)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("CARD HOLDER")
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.7))
                            Text(cardHolder.uppercased())
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("EXPIRES")
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.7))
                            Text(expiryDate)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(20)
            }
            .aspectRatio(1.586, contentMode: .fit)
        } back: {
            // Back
            ZStack {
                gradient
                
                VStack(spacing: 20) {
                    Rectangle()
                        .fill(.black)
                        .frame(height: 50)
                        .padding(.top, 20)
                    
                    HStack {
                        Spacer()
                        
                        ZStack(alignment: .trailing) {
                            Rectangle()
                                .fill(.white)
                                .frame(width: 200, height: 40)
                            
                            Text(cvv)
                                .font(.system(.body, design: .monospaced))
                                .fontWeight(.medium)
                                .padding(.trailing, 12)
                        }
                        .padding(.trailing, 20)
                    }
                    
                    Spacer()
                }
            }
            .aspectRatio(1.586, contentMode: .fit)
        }
    }
    
    private func formatCardNumber(_ number: String) -> String {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        var result = ""
        for (index, char) in cleaned.enumerated() {
            if index > 0 && index % 4 == 0 {
                result += " "
            }
            result.append(char)
        }
        return result
    }
}

#if DEBUG
struct FlipCardPreview: View {
    @State private var isFlipped1 = false
    @State private var isFlipped2 = false
    
    var body: some View {
        VStack(spacing: 30) {
            FlipCard(isFlipped: $isFlipped1) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.blue)
                    .overlay(
                        Text("Front")
                            .font(.title)
                            .foregroundStyle(.white)
                    )
                    .frame(height: 200)
            } back: {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.green)
                    .overlay(
                        Text("Back")
                            .font(.title)
                            .foregroundStyle(.white)
                    )
                    .frame(height: 200)
            }
            
            CreditCardFlipCard(
                isFlipped: $isFlipped2,
                cardNumber: "4242424242424242",
                cardHolder: "John Doe",
                expiryDate: "12/28",
                cvv: "123"
            )
            .frame(maxWidth: 340)
            
            Button("Flip All") {
                isFlipped1.toggle()
                isFlipped2.toggle()
            }
        }
        .padding()
    }
}

#Preview {
    FlipCardPreview()
}
#endif
