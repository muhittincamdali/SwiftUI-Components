import Foundation

/// The outcome of checking a value against a ``Validator``.
public enum ValidationResult: Equatable, Sendable {
    case valid
    case invalid(String)

    /// `true` for ``valid``.
    public var isValid: Bool { self == .valid }

    /// The message of an ``invalid(_:)`` result, otherwise `nil`.
    public var message: String? {
        if case .invalid(let message) = self { return message }
        return nil
    }
}

/// A reusable check for one kind of value, such as the text of an email field.
///
/// Build validators from the static factories and combine them with ``and(_:)``:
///
/// ```swift
/// let email: Validator<String> = .required().and(.email())
/// email.validate("")            // .invalid("This field is required")
/// email.validate("ada@example") // .invalid("Enter a valid email address")
/// ```
///
/// Every factory except `required` accepts an empty value, so an optional field only reports
/// a problem once the user types something.
public struct Validator<Value>: Sendable {
    private let rule: @Sendable (Value) -> ValidationResult

    /// Creates a validator from a closure that returns the result for a value.
    public init(_ rule: @escaping @Sendable (Value) -> ValidationResult) {
        self.rule = rule
    }

    /// Checks `value`.
    public func validate(_ value: Value) -> ValidationResult {
        rule(value)
    }

    /// A validator that passes when `isValid` returns `true` and otherwise reports `message`.
    public static func custom(
        _ message: String,
        _ isValid: @escaping @Sendable (Value) -> Bool
    ) -> Validator {
        Validator { isValid($0) ? .valid : .invalid(message) }
    }

    /// A validator that runs `self` and then `other`, and reports the first failure.
    public func and(_ other: Validator) -> Validator {
        Validator { value in
            let first = self.validate(value)
            return first.isValid ? other.validate(value) : first
        }
    }

    /// A validator that passes when either `self` or `other` passes.
    ///
    /// When both fail it reports `message`, or the message of `self` when `message` is `nil`.
    public func or(_ other: Validator, message: String? = nil) -> Validator {
        Validator { value in
            let first = self.validate(value)
            guard !first.isValid else { return .valid }
            guard !other.validate(value).isValid else { return .valid }
            return message.map(ValidationResult.invalid) ?? first
        }
    }

    /// A validator that runs every validator in order and reports the first failure.
    ///
    /// An empty array always passes.
    public static func all(_ validators: [Validator]) -> Validator {
        Validator { value in
            for validator in validators {
                let result = validator.validate(value)
                if !result.isValid { return result }
            }
            return .valid
        }
    }
}

// MARK: - Text

extension Validator where Value == String {
    /// Fails when the text is empty or contains only whitespace and newlines.
    public static func required(_ message: String = "This field is required") -> Validator {
        .custom(message) { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    /// Fails when the text has fewer than `count` characters.
    public static func minLength(_ count: Int, message: String? = nil) -> Validator {
        let message = message ?? "Use at least \(count) characters"
        return .custom(message) { $0.isEmpty || $0.count >= count }
    }

    /// Fails when the text has more than `count` characters.
    public static func maxLength(_ count: Int, message: String? = nil) -> Validator {
        let message = message ?? "Use at most \(count) characters"
        return .custom(message) { $0.count <= count }
    }

    /// Fails unless the text looks like an email address: one `@`, a non-empty local part, and a
    /// domain with at least one dot and no spaces.
    ///
    /// This is a format check only. The only way to know that an address exists is to send it
    /// a message.
    public static func email(_ message: String = "Enter a valid email address") -> Validator {
        .custom(message) { text in
            text.isEmpty || text.wholeMatch(of: /[^@\s]+@[^@\s.]+(\.[^@\s.]+)+/) != nil
        }
    }

    /// Fails unless the text is an absolute `http` or `https` URL with a host.
    public static func url(_ message: String = "Enter a valid web address") -> Validator {
        .custom(message) { text in
            guard !text.isEmpty else { return true }
            guard let components = URLComponents(string: text),
                  let scheme = components.scheme?.lowercased(),
                  let host = components.host, !host.isEmpty
            else { return false }
            return scheme == "http" || scheme == "https"
        }
    }

    /// Fails unless the text contains only the digits 0–9.
    public static func digits(_ message: String = "Use digits only") -> Validator {
        .custom(message) { text in text.allSatisfy { ("0"..."9").contains($0) } }
    }

    /// Fails unless the text is a phone number with 7 to 15 digits.
    ///
    /// Spaces, dashes, dots and parentheses are ignored and a single leading `+` is allowed.
    /// Fifteen digits is the longest number the E.164 numbering plan allows.
    public static func phone(_ message: String = "Enter a valid phone number") -> Validator {
        .custom(message) { text in
            guard !text.isEmpty else { return true }
            let body = text.hasPrefix("+") ? text.dropFirst() : Substring(text)
            let separators: Set<Character> = [" ", "-", ".", "(", ")"]
            guard body.allSatisfy({ ("0"..."9").contains($0) || separators.contains($0) }) else {
                return false
            }
            let digitCount = body.filter { ("0"..."9").contains($0) }.count
            return (7...15).contains(digitCount)
        }
    }

    /// Fails unless the whole text matches the regular expression `pattern`.
    ///
    /// An invalid pattern makes every non-empty value fail, so a typo in the pattern shows up
    /// the first time you try the field.
    ///
    /// Use patterns you wrote yourself. `Regex` backtracks, so a pattern such as `(a+)+$` can take
    /// exponential time; ``FormSchema/check()`` rejects such patterns in a schema.
    public static func matches(_ pattern: String, message: String = "Invalid format") -> Validator {
        .custom(message) { text in
            guard !text.isEmpty else { return true }
            guard let regex = try? Regex(pattern) else { return false }
            return (try? regex.wholeMatch(in: text)) != nil
        }
    }

    /// Fails unless the text equals `other`, for example to confirm a password.
    public static func equals(_ other: String, message: String = "The values don't match") -> Validator {
        .custom(message) { $0 == other }
    }
}

// MARK: - Comparable values

extension Validator where Value: Comparable & Sendable {
    /// Fails when the value is outside `range`.
    public static func range(_ range: ClosedRange<Value>, message: String? = nil) -> Validator {
        let message = message ?? "Choose a value from \(range.lowerBound) to \(range.upperBound)"
        return .custom(message) { range.contains($0) }
    }

    /// Fails when the value is less than `minimum`.
    public static func atLeast(_ minimum: Value, message: String? = nil) -> Validator {
        let message = message ?? "Choose \(minimum) or more"
        return .custom(message) { $0 >= minimum }
    }

    /// Fails when the value is greater than `maximum`.
    public static func atMost(_ maximum: Value, message: String? = nil) -> Validator {
        let message = message ?? "Choose \(maximum) or less"
        return .custom(message) { $0 <= maximum }
    }
}

// MARK: - Collections

extension Validator where Value: Collection & Sendable {
    /// Fails when the collection is empty, for example a multi-select with nothing selected.
    public static func notEmpty(_ message: String = "Choose at least one option") -> Validator {
        .custom(message) { !$0.isEmpty }
    }

    /// Fails when the number of elements is outside `allowed`.
    public static func count(
        _ allowed: ClosedRange<Int>,
        message: String? = nil
    ) -> Validator {
        let message = message ?? "Choose \(allowed.lowerBound) to \(allowed.upperBound) options"
        return .custom(message) { allowed.contains($0.count) }
    }
}
