import Foundation

/// The text rules shared by the one-time-code and PIN fields.
///
/// The fields read their text from a hidden text field, so pasted or autofilled text arrives
/// unfiltered: it can be longer than the code, contain separators such as `"123-456"`, or contain
/// digits from other scripts such as `"١٢٣"` that `Character.isNumber` accepts but a server
/// expecting 0–9 does not.
enum CodeEntry {
    /// Which characters a code may contain.
    enum Characters {
        /// The ASCII digits 0–9.
        case digits
        /// The ASCII letters and digits.
        case lettersAndDigits

        func allows(_ character: Character) -> Bool {
            guard character.isASCII else { return false }
            switch self {
            case .digits: return character.isNumber
            case .lettersAndDigits: return character.isLetter || character.isNumber
            }
        }
    }

    /// The number of cells a field shows: at least one, so a zero or negative `length` cannot
    /// build an empty or invalid range.
    static func cellCount(_ length: Int) -> Int {
        max(1, length)
    }

    /// Keeps the allowed characters of `text`, then the first `length` of them.
    ///
    /// Filtering first keeps every digit of a pasted `"123-456"`; cutting first would drop one.
    static func sanitize(_ text: String, length: Int, allowing characters: Characters) -> String {
        String(text.filter(characters.allows).prefix(cellCount(length)))
    }
}
