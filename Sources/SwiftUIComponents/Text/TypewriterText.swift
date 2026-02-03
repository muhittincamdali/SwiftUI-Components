import SwiftUI

/// Text that animates character-by-character like a typewriter.
///
/// `TypewriterText` creates an engaging typing animation effect,
/// perfect for onboarding screens or dynamic content reveals.
///
/// ```swift
/// TypewriterText("Hello, World!", typingSpeed: 0.05)
/// ```
public struct TypewriterText: View {
    // MARK: - Properties
    
    private let text: String
    private let typingSpeed: Double
    private let cursorBlinkSpeed: Double
    private let showCursor: Bool
    private let cursorCharacter: String
    private let font: Font
    private let textColor: Color
    private let cursorColor: Color
    private let onComplete: (() -> Void)?
    
    @State private var displayedText: String = ""
    @State private var cursorVisible: Bool = true
    @State private var isTyping: Bool = false
    @State private var currentIndex: Int = 0
    
    // MARK: - Initialization
    
    /// Creates a new typewriter text view.
    /// - Parameters:
    ///   - text: The full text to animate.
    ///   - typingSpeed: Delay between characters in seconds. Defaults to `0.05`.
    ///   - cursorBlinkSpeed: Cursor blink interval. Defaults to `0.5`.
    ///   - showCursor: Whether to show a blinking cursor. Defaults to `true`.
    ///   - cursorCharacter: The cursor character. Defaults to `"|"`.
    ///   - font: The text font. Defaults to `.body`.
    ///   - textColor: Text color. Defaults to `.primary`.
    ///   - cursorColor: Cursor color. Defaults to `.blue`.
    ///   - onComplete: Callback when typing completes. Defaults to `nil`.
    public init(
        _ text: String,
        typingSpeed: Double = 0.05,
        cursorBlinkSpeed: Double = 0.5,
        showCursor: Bool = true,
        cursorCharacter: String = "|",
        font: Font = .body,
        textColor: Color = .primary,
        cursorColor: Color = .blue,
        onComplete: (() -> Void)? = nil
    ) {
        self.text = text
        self.typingSpeed = typingSpeed
        self.cursorBlinkSpeed = cursorBlinkSpeed
        self.showCursor = showCursor
        self.cursorCharacter = cursorCharacter
        self.font = font
        self.textColor = textColor
        self.cursorColor = cursorColor
        self.onComplete = onComplete
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 0) {
            Text(displayedText)
                .font(font)
                .foregroundStyle(textColor)
            
            if showCursor {
                Text(cursorCharacter)
                    .font(font)
                    .foregroundStyle(cursorColor)
                    .opacity(cursorVisible ? 1 : 0)
            }
        }
        .onAppear {
            startTyping()
            startCursorBlink()
        }
    }
    
    // MARK: - Animation
    
    private func startTyping() {
        guard !isTyping else { return }
        isTyping = true
        displayedText = ""
        currentIndex = 0
        
        typeNextCharacter()
    }
    
    private func typeNextCharacter() {
        guard currentIndex < text.count else {
            isTyping = false
            onComplete?()
            return
        }
        
        let index = text.index(text.startIndex, offsetBy: currentIndex)
        displayedText.append(text[index])
        currentIndex += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + typingSpeed) {
            typeNextCharacter()
        }
    }
    
    private func startCursorBlink() {
        Timer.scheduledTimer(withTimeInterval: cursorBlinkSpeed, repeats: true) { _ in
            cursorVisible.toggle()
        }
    }
}

// MARK: - Advanced Typewriter

/// A more feature-rich typewriter with backspace and multi-text support.
public struct AdvancedTypewriterText: View {
    // MARK: - Types
    
    /// Configuration for text sequence animation.
    public struct TextSequence: Identifiable {
        public let id = UUID()
        public let text: String
        public let typingSpeed: Double
        public let pauseDuration: Double
        public let deleteAfter: Bool
        public let deleteSpeed: Double
        
        public init(
            text: String,
            typingSpeed: Double = 0.05,
            pauseDuration: Double = 2.0,
            deleteAfter: Bool = true,
            deleteSpeed: Double = 0.03
        ) {
            self.text = text
            self.typingSpeed = typingSpeed
            self.pauseDuration = pauseDuration
            self.deleteAfter = deleteAfter
            self.deleteSpeed = deleteSpeed
        }
    }
    
    // MARK: - Properties
    
    private let sequences: [TextSequence]
    private let loop: Bool
    private let font: Font
    private let textColor: Color
    private let cursorColor: Color
    
    @State private var displayedText: String = ""
    @State private var currentSequenceIndex: Int = 0
    @State private var isAnimating: Bool = false
    
    // MARK: - Initialization
    
    /// Creates an advanced typewriter with multiple text sequences.
    public init(
        sequences: [TextSequence],
        loop: Bool = true,
        font: Font = .body,
        textColor: Color = .primary,
        cursorColor: Color = .blue
    ) {
        self.sequences = sequences
        self.loop = loop
        self.font = font
        self.textColor = textColor
        self.cursorColor = cursorColor
    }
    
    /// Convenience initializer for simple looping text.
    public init(
        texts: [String],
        typingSpeed: Double = 0.05,
        pauseDuration: Double = 2.0,
        loop: Bool = true,
        font: Font = .body
    ) {
        self.sequences = texts.map { TextSequence(text: $0, typingSpeed: typingSpeed, pauseDuration: pauseDuration) }
        self.loop = loop
        self.font = font
        self.textColor = .primary
        self.cursorColor = .blue
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 0) {
            Text(displayedText)
                .font(font)
                .foregroundStyle(textColor)
            
            Text("|")
                .font(font)
                .foregroundStyle(cursorColor)
                .opacity(cursorOpacity)
        }
        .onAppear {
            startAnimation()
        }
    }
    
    @State private var cursorOpacity: Double = 1.0
    
    // MARK: - Animation Logic
    
    private func startAnimation() {
        guard !isAnimating && !sequences.isEmpty else { return }
        isAnimating = true
        
        // Start cursor blink
        withAnimation(.easeInOut(duration: 0.5).repeatForever()) {
            cursorOpacity = 0.0
        }
        
        animateSequence(at: 0)
    }
    
    private func animateSequence(at index: Int) {
        guard index < sequences.count else {
            if loop {
                animateSequence(at: 0)
            } else {
                isAnimating = false
            }
            return
        }
        
        let sequence = sequences[index]
        currentSequenceIndex = index
        
        // Type the text
        typeText(sequence.text, speed: sequence.typingSpeed) {
            // Pause
            DispatchQueue.main.asyncAfter(deadline: .now() + sequence.pauseDuration) {
                if sequence.deleteAfter {
                    // Delete the text
                    deleteText(speed: sequence.deleteSpeed) {
                        // Move to next sequence
                        animateSequence(at: index + 1)
                    }
                } else {
                    animateSequence(at: index + 1)
                }
            }
        }
    }
    
    private func typeText(_ text: String, speed: Double, completion: @escaping () -> Void) {
        var charIndex = 0
        
        func typeNext() {
            guard charIndex < text.count else {
                completion()
                return
            }
            
            let index = text.index(text.startIndex, offsetBy: charIndex)
            displayedText.append(text[index])
            charIndex += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
                typeNext()
            }
        }
        
        typeNext()
    }
    
    private func deleteText(speed: Double, completion: @escaping () -> Void) {
        func deleteNext() {
            guard !displayedText.isEmpty else {
                completion()
                return
            }
            
            displayedText.removeLast()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
                deleteNext()
            }
        }
        
        deleteNext()
    }
}

// MARK: - Code Typewriter

/// A typewriter styled for code with syntax highlighting.
public struct CodeTypewriterText: View {
    private let code: String
    private let language: CodeLanguage
    private let typingSpeed: Double
    private let fontSize: CGFloat
    
    @State private var displayedCode: String = ""
    
    /// Supported code languages for highlighting.
    public enum CodeLanguage {
        case swift
        case javascript
        case python
        case plain
    }
    
    public init(
        code: String,
        language: CodeLanguage = .swift,
        typingSpeed: Double = 0.03,
        fontSize: CGFloat = 14
    ) {
        self.code = code
        self.language = language
        self.typingSpeed = typingSpeed
        self.fontSize = fontSize
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(displayedCode)
                .font(.system(size: fontSize, design: .monospaced))
                .foregroundStyle(.primary)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .onAppear {
            startTyping()
        }
    }
    
    private func startTyping() {
        var index = 0
        
        func typeNext() {
            guard index < code.count else { return }
            
            let charIndex = code.index(code.startIndex, offsetBy: index)
            displayedCode.append(code[charIndex])
            index += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + typingSpeed) {
                typeNext()
            }
        }
        
        typeNext()
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 40) {
        TypewriterText(
            "Hello, World! Welcome to SwiftUI.",
            typingSpeed: 0.08,
            font: .title2
        )
        
        AdvancedTypewriterText(
            texts: [
                "Developer",
                "Designer",
                "Creator"
            ],
            typingSpeed: 0.1,
            pauseDuration: 1.5,
            font: .largeTitle.bold()
        )
        
        CodeTypewriterText(
            code: "struct Hello: View {\n    var body: some View {\n        Text(\"Hello\")\n    }\n}",
            language: .swift
        )
    }
    .padding()
}
#endif
