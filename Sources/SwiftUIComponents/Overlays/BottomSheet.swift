import SwiftUI

/// A draggable bottom sheet overlay with snap points.
///
/// `BottomSheet` provides a customizable sheet that slides up from
/// the bottom with gesture-driven behavior.
///
/// ```swift
/// BottomSheet(isPresented: $isShowing) {
///     Text("Sheet Content")
/// }
/// ```
public struct BottomSheet<Content: View>: View {
    // MARK: - Types
    
    /// Snap points for the sheet height.
    public enum DetentHeight {
        case small
        case medium
        case large
        case full
        case custom(CGFloat)
        case fraction(CGFloat)
        
        func height(in containerHeight: CGFloat) -> CGFloat {
            switch self {
            case .small: return containerHeight * 0.25
            case .medium: return containerHeight * 0.5
            case .large: return containerHeight * 0.75
            case .full: return containerHeight
            case .custom(let height): return height
            case .fraction(let fraction): return containerHeight * fraction
            }
        }
    }
    
    // MARK: - Properties
    
    @Binding private var isPresented: Bool
    private let detents: [DetentHeight]
    private let showDragIndicator: Bool
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let shadowRadius: CGFloat
    private let dismissOnBackgroundTap: Bool
    private let content: () -> Content
    
    @State private var currentDetent: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var sheetHeight: CGFloat = 0
    @GestureState private var isDragging: Bool = false
    
    // MARK: - Initialization
    
    /// Creates a new bottom sheet.
    public init(
        isPresented: Binding<Bool>,
        detents: [DetentHeight] = [.medium, .large],
        showDragIndicator: Bool = true,
        backgroundColor: Color = Color(.systemBackground),
        cornerRadius: CGFloat = 20,
        shadowRadius: CGFloat = 10,
        dismissOnBackgroundTap: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.detents = detents.isEmpty ? [.medium] : detents
        self.showDragIndicator = showDragIndicator
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.dismissOnBackgroundTap = dismissOnBackgroundTap
        self.content = content
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Background overlay
                if isPresented {
                    Color.black
                        .opacity(0.4 * min(1, sheetHeight / geometry.size.height))
                        .ignoresSafeArea()
                        .onTapGesture {
                            if dismissOnBackgroundTap {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    isPresented = false
                                }
                            }
                        }
                        .transition(.opacity)
                }
                
                // Sheet
                if isPresented {
                    sheetContent(in: geometry)
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isPresented)
    }
    
    // MARK: - Sheet Content
    
    private func sheetContent(in geometry: GeometryProxy) -> some View {
        let currentHeight = detents[currentDetent].height(in: geometry.size.height)
        
        return VStack(spacing: 0) {
            // Drag indicator
            if showDragIndicator {
                dragIndicator
            }
            
            // Content
            content()
                .frame(maxWidth: .infinity)
        }
        .frame(height: max(0, currentHeight - dragOffset), alignment: .top)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(backgroundColor)
                .shadow(color: .black.opacity(0.15), radius: shadowRadius, y: -5)
        )
        .gesture(dragGesture(in: geometry))
        .onAppear {
            sheetHeight = currentHeight
        }
        .onChange(of: currentDetent) { _, newValue in
            sheetHeight = detents[newValue].height(in: geometry.size.height)
        }
    }
    
    // MARK: - Drag Indicator
    
    private var dragIndicator: some View {
        Capsule()
            .fill(Color(.systemGray4))
            .frame(width: 36, height: 5)
            .padding(.top, 8)
            .padding(.bottom, 4)
    }
    
    // MARK: - Drag Gesture
    
    private func dragGesture(in geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .updating($isDragging) { _, state, _ in
                state = true
            }
            .onChanged { value in
                dragOffset = value.translation.height
            }
            .onEnded { value in
                let velocity = value.predictedEndLocation.y - value.location.y
                handleDragEnd(
                    translation: value.translation.height,
                    velocity: velocity,
                    containerHeight: geometry.size.height
                )
            }
    }
    
    private func handleDragEnd(translation: CGFloat, velocity: CGFloat, containerHeight: CGFloat) {
        let currentHeight = detents[currentDetent].height(in: containerHeight)
        let targetHeight = currentHeight - translation
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            dragOffset = 0
            
            // Check for dismiss
            if translation > 100 || velocity > 500 {
                if currentDetent == 0 {
                    isPresented = false
                    return
                }
            }
            
            // Find closest detent
            var closestDetent = currentDetent
            var closestDistance = CGFloat.infinity
            
            for (index, detent) in detents.enumerated() {
                let height = detent.height(in: containerHeight)
                let distance = abs(height - targetHeight)
                
                // Prefer direction of gesture
                if velocity > 200 && index < currentDetent {
                    closestDetent = index
                    break
                } else if velocity < -200 && index > currentDetent {
                    closestDetent = index
                    break
                } else if distance < closestDistance {
                    closestDistance = distance
                    closestDetent = index
                }
            }
            
            currentDetent = closestDetent
        }
    }
}

// MARK: - Bottom Sheet Modifier

/// A modifier that presents content in a bottom sheet.
public struct BottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let detents: [BottomSheet<SheetContent>.DetentHeight]
    let content: () -> SheetContent
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            BottomSheet(
                isPresented: $isPresented,
                detents: detents,
                content: self.content
            )
        }
    }
}

extension View {
    /// Presents a bottom sheet.
    public func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        detents: [BottomSheet<Content>.DetentHeight] = [.medium, .large],
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(BottomSheetModifier(isPresented: isPresented, detents: detents, content: content))
    }
}

// MARK: - Fixed Height Bottom Sheet

/// A simpler bottom sheet with fixed height.
public struct FixedBottomSheet<Content: View>: View {
    @Binding private var isPresented: Bool
    private let height: CGFloat
    private let content: () -> Content
    
    public init(
        isPresented: Binding<Bool>,
        height: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.height = height
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
                
                VStack {
                    content()
                }
                .frame(height: height)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                )
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isPresented)
    }
}

#if DEBUG
struct BottomSheetPreview: View {
    @State private var showSheet = false
    @State private var showFixedSheet = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Button("Show Bottom Sheet") {
                    showSheet = true
                }
                
                Button("Show Fixed Sheet") {
                    showFixedSheet = true
                }
            }
            
            BottomSheet(isPresented: $showSheet, detents: [.small, .medium, .large]) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Bottom Sheet")
                        .font(.headline)
                    
                    Text("Drag to resize or dismiss. This sheet has three detent heights.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                }
                .padding()
            }
            
            FixedBottomSheet(isPresented: $showFixedSheet, height: 200) {
                VStack {
                    Text("Fixed Height Sheet")
                        .font(.headline)
                    Text("This sheet has a fixed height of 200pt")
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
        }
    }
}

#Preview {
    BottomSheetPreview()
}
#endif
