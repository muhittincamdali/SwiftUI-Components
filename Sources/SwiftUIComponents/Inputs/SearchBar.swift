import SwiftUI

/// A search bar with a clear button and customizable appearance.
///
/// Provides a familiar search experience with an SF Symbol magnifying glass,
/// placeholder text, and a clear button that appears when text is entered.
///
/// ```swift
/// @State private var query = ""
///
/// SearchBar(text: $query, placeholder: "Search...")
/// ```
public struct SearchBar: View {
    // MARK: - Properties

    @Binding private var text: String
    private let placeholder: String
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let showCancelButton: Bool

    @FocusState private var isFocused: Bool

    // MARK: - Initialization

    /// Creates a new search bar.
    /// - Parameters:
    ///   - text: A binding to the search text.
    ///   - placeholder: The placeholder text. Defaults to `"Search..."`.
    ///   - backgroundColor: The background color. Defaults to a light gray.
    ///   - cornerRadius: The corner radius. Defaults to `10`.
    ///   - showCancelButton: Whether to show a cancel button when focused. Defaults to `true`.
    public init(
        text: Binding<String>,
        placeholder: String = "Search...",
        backgroundColor: Color = Color(.systemGray6),
        cornerRadius: CGFloat = 10,
        showCancelButton: Bool = true
    ) {
        self._text = text
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.showCancelButton = showCancelButton
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 16))

                TextField(placeholder, text: $text)
                    .focused($isFocused)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)

                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 16))
                    }
                    .buttonStyle(.plain)
                    .transition(.opacity.combined(with: .scale))
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )

            if showCancelButton && isFocused {
                Button("Cancel") {
                    text = ""
                    isFocused = false
                }
                .foregroundStyle(.blue)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

#if DEBUG
struct SearchBarPreview: View {
    @State private var query = ""

    var body: some View {
        SearchBar(text: $query, placeholder: "Search products...")
            .padding()
    }
}

#Preview {
    SearchBarPreview()
}
#endif
