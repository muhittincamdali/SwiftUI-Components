import Foundation

/// A value entered in a ``SchemaForm``: text, a number or an on/off switch.
///
/// It encodes as a plain JSON value, so `[String: FormValue]` becomes an object such as
/// `{"email": "ada@example.com", "age": 36, "newsletter": true}`. JSON has no NaN or infinity,
/// so encoding a `.number` that is not finite throws; ``FormSchema/errors(in:)`` reports such
/// numbers as invalid.
public enum FormValue: Codable, Equatable, Sendable {
    case text(String)
    case number(Double)
    case bool(Bool)

    /// The text, or `nil` for other cases.
    public var text: String? {
        if case .text(let text) = self { return text }
        return nil
    }

    /// The number, or `nil` for other cases.
    public var number: Double? {
        if case .number(let number) = self { return number }
        return nil
    }

    /// The switch state, or `nil` for other cases.
    public var bool: Bool? {
        if case .bool(let bool) = self { return bool }
        return nil
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let number = try? container.decode(Double.self) {
            self = .number(number)
        } else {
            self = .text(try container.decode(String.self))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .text(let text): try container.encode(text)
        case .number(let number): try container.encode(number)
        case .bool(let bool): try container.encode(bool)
        }
    }
}

/// A form described as data, for example JSON sent by your server, that ``SchemaForm`` renders
/// and validates.
///
/// ```json
/// {
///   "title": "Contact",
///   "fields": [
///     { "id": "email", "label": "Email", "kind": "email", "required": true },
///     { "id": "age", "label": "Age", "kind": "number", "minimum": 18, "maximum": 120 },
///     { "id": "plan", "label": "Plan", "kind": "choice", "options": ["Free", "Pro"] }
///   ]
/// }
/// ```
public struct FormSchema: Codable, Equatable, Sendable {
    /// An optional heading shown above the fields.
    public var title: String?
    /// The fields in display order.
    public var fields: [Field]

    /// Creates a schema from fields.
    public init(title: String? = nil, fields: [Field]) {
        self.title = title
        self.fields = fields
    }

    /// Problems ``FormSchema/decode(from:)`` reports beyond malformed JSON.
    public enum SchemaError: Error, Equatable, Sendable {
        /// Two fields use the same `id`.
        case duplicateID(String)
        /// A `choice` field has no options.
        case missingOptions(String)
        /// A field's `pattern` is not a valid regular expression.
        case invalidPattern(String)
        /// A field's `pattern` could freeze the app on some inputs: it repeats a group that can
        /// match the same text in more than one way, such as `(a+)+` or `(a|a)+`, chains too many
        /// open-ended repetitions, such as `\d+\d+\d+\d+x`, uses `\Q…\E`, `(?#…)` or the
        /// `x` option, or is longer than 500 characters. Values longer than 256 characters are
        /// never matched against a pattern; they fail it.
        case unsafePattern(String)
        /// A field's length or number limits are negative, not finite, or the minimum is above
        /// the maximum.
        case invalidLimits(String)
    }

    /// Decodes a schema from JSON and checks that it can be rendered.
    public static func decode(from data: Data) throws -> FormSchema {
        let schema = try JSONDecoder().decode(FormSchema.self, from: data)
        try schema.check()
        return schema
    }

    /// Throws a ``SchemaError`` for duplicate ids, choice fields without options, invalid or
    /// unsafe patterns and impossible limits.
    ///
    /// Run it on every schema you did not write yourself; ``decode(from:)`` does.
    public func check() throws {
        var seen: Set<String> = []
        for field in fields {
            guard seen.insert(field.id).inserted else { throw SchemaError.duplicateID(field.id) }
            if field.kind == .choice, (field.options ?? []).isEmpty {
                throw SchemaError.missingOptions(field.id)
            }
            if let pattern = field.pattern {
                guard (try? Regex(pattern)) != nil else { throw SchemaError.invalidPattern(field.id) }
                guard PatternSafety.isSafe(pattern) else { throw SchemaError.unsafePattern(field.id) }
            }
            guard field.hasValidLimits else { throw SchemaError.invalidLimits(field.id) }
        }
    }

    /// The starting values: empty text, switches off, numbers and choices unset.
    public func initialValues() -> [String: FormValue] {
        var values: [String: FormValue] = [:]
        for field in fields {
            switch field.kind {
            case .toggle: values[field.id] = .bool(false)
            case .number, .choice: break
            default: values[field.id] = .text("")
            }
        }
        return values
    }

    /// The error message for each invalid field, keyed by field id. Empty when the form is valid.
    public func errors(in values: [String: FormValue]) -> [String: String] {
        var errors: [String: String] = [:]
        for field in fields {
            if let message = field.error(for: values[field.id]) {
                errors[field.id] = message
            }
        }
        return errors
    }
}

extension FormSchema {
    /// The kind of control a field uses.
    public enum Kind: String, Codable, Sendable, CaseIterable {
        case text, email, phone, url, password, multiline, number, toggle, choice
    }

    /// One field of a ``FormSchema``.
    public struct Field: Codable, Equatable, Sendable, Identifiable {
        /// The key of the field's value in the values dictionary. Must be unique.
        public var id: String
        public var label: String
        public var kind: Kind
        public var placeholder: String?
        /// Shown under the field while it has no error.
        public var help: String?
        /// For text kinds: must not be blank. For `toggle`: must be on. For `number` and
        /// `choice`: must have a value.
        public var isRequired: Bool
        public var minLength: Int?
        public var maxLength: Int?
        /// A regular expression the whole text must match.
        public var pattern: String?
        /// The message for a `pattern` mismatch.
        public var patternMessage: String?
        public var minimum: Double?
        public var maximum: Double?
        /// The choices of a `choice` field.
        public var options: [String]?

        enum CodingKeys: String, CodingKey {
            case id, label, kind, placeholder, help, minLength, maxLength, pattern, patternMessage
            case minimum, maximum, options
            case isRequired = "required"
        }

        public init(
            id: String,
            label: String,
            kind: Kind = .text,
            placeholder: String? = nil,
            help: String? = nil,
            isRequired: Bool = false,
            minLength: Int? = nil,
            maxLength: Int? = nil,
            pattern: String? = nil,
            patternMessage: String? = nil,
            minimum: Double? = nil,
            maximum: Double? = nil,
            options: [String]? = nil
        ) {
            self.id = id
            self.label = label
            self.kind = kind
            self.placeholder = placeholder
            self.help = help
            self.isRequired = isRequired
            self.minLength = minLength
            self.maxLength = maxLength
            self.pattern = pattern
            self.patternMessage = patternMessage
            self.minimum = minimum
            self.maximum = maximum
            self.options = options
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            label = try container.decode(String.self, forKey: .label)
            kind = try container.decodeIfPresent(Kind.self, forKey: .kind) ?? .text
            placeholder = try container.decodeIfPresent(String.self, forKey: .placeholder)
            help = try container.decodeIfPresent(String.self, forKey: .help)
            isRequired = try container.decodeIfPresent(Bool.self, forKey: .isRequired) ?? false
            minLength = try container.decodeIfPresent(Int.self, forKey: .minLength)
            maxLength = try container.decodeIfPresent(Int.self, forKey: .maxLength)
            pattern = try container.decodeIfPresent(String.self, forKey: .pattern)
            patternMessage = try container.decodeIfPresent(String.self, forKey: .patternMessage)
            minimum = try container.decodeIfPresent(Double.self, forKey: .minimum)
            maximum = try container.decodeIfPresent(Double.self, forKey: .maximum)
            options = try container.decodeIfPresent([String].self, forKey: .options)
        }

        /// `false` when a length limit is negative, a number limit is not finite, or a minimum
        /// is above its maximum.
        var hasValidLimits: Bool {
            if let minLength, minLength < 0 { return false }
            if let maxLength, maxLength < 0 { return false }
            if let minLength, let maxLength, minLength > maxLength { return false }
            if let minimum, !minimum.isFinite { return false }
            if let maximum, !maximum.isFinite { return false }
            if let minimum, let maximum, minimum > maximum { return false }
            return true
        }

        /// The error message for `value`, or `nil` when it is valid.
        public func error(for value: FormValue?) -> String? {
            switch kind {
            case .toggle:
                return isRequired && value?.bool != true ? "Turn this on to continue" : nil
            case .number:
                return numberError(value?.number)
            case .choice:
                return choiceError(value?.text)
            default:
                return textValidator.validate(value?.text ?? "").message
            }
        }

        private var textValidator: Validator<String> {
            var validators: [Validator<String>] = []
            if isRequired { validators.append(.required()) }
            if let minLength { validators.append(.minLength(minLength)) }
            if let maxLength { validators.append(.maxLength(maxLength)) }
            switch kind {
            case .email: validators.append(.email())
            case .phone: validators.append(.phone())
            case .url: validators.append(.url())
            default: break
            }
            if let pattern {
                let message = patternMessage ?? "Invalid format"
                // A schema can come from a server and may not have been checked, so an unsafe
                // pattern fails every value instead of running, and long text never reaches it.
                let isSafe = PatternSafety.isSafe(pattern)
                validators.append(.custom(message) {
                    $0.isEmpty || (isSafe && $0.count <= PatternSafety.maximumInputLength)
                })
                validators.append(.matches(pattern, message: message))
            }
            return .all(validators)
        }

        private func numberError(_ number: Double?) -> String? {
            guard let number else { return isRequired ? "This field is required" : nil }
            // NaN fails every comparison, so without this it would pass any minimum and maximum.
            guard number.isFinite else { return "Enter a number" }
            if let minimum, number < minimum { return "Enter \(minimum.formatted()) or more" }
            if let maximum, number > maximum { return "Enter \(maximum.formatted()) or less" }
            return nil
        }

        private func choiceError(_ choice: String?) -> String? {
            guard let choice, !choice.isEmpty else { return isRequired ? "Choose an option" : nil }
            return (options ?? []).contains(choice) ? nil : "Choose one of the listed options"
        }
    }
}
