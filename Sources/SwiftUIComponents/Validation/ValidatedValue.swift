import Foundation

/// A form value together with its ``Validator`` and whether its error should be shown yet.
///
/// Keep one `ValidatedValue` per field in `@State` and bind the control to ``value``.
/// ``visibleError`` stays `nil` until the user edits the field or you call ``validate()``,
/// so a fresh form does not open full of red messages.
///
/// ```swift
/// struct SignUpForm: View {
///     @State private var email = ValidatedValue("", .required().and(.email()))
///
///     var body: some View {
///         FormField(label: "Email", errorMessage: email.visibleError) {
///             TextInputField(text: $email.value, keyboardType: .email)
///         }
///         PrimaryButton("Sign up") {
///             if email.validate() { /* submit */ }
///         }
///     }
/// }
/// ```
public struct ValidatedValue<Value> {
    /// The current value. Setting it marks the field as edited.
    public var value: Value {
        didSet { isEdited = true }
    }

    /// The check applied to ``value``. Replace it when the rule depends on another field.
    public var validator: Validator<Value>

    /// `true` once ``value`` has been set after initialization.
    public private(set) var isEdited = false

    /// `true` once ``validate()`` has been called.
    public private(set) var isChecked = false

    /// Creates a field with an initial value and its validator.
    public init(_ value: Value, _ validator: Validator<Value>) {
        self.value = value
        self.validator = validator
    }

    /// The result of validating the current value, whether or not it is shown.
    public var result: ValidationResult { validator.validate(value) }

    /// `true` when the current value passes the validator.
    public var isValid: Bool { result.isValid }

    /// The error for the current value, or `nil` when it is valid or the user has not edited
    /// the field and ``validate()`` has not been called.
    public var visibleError: String? {
        isEdited || isChecked ? result.message : nil
    }

    /// Makes the error visible from now on and returns whether the value is valid.
    ///
    /// Call it for every field when the user submits the form.
    @discardableResult
    public mutating func validate() -> Bool {
        isChecked = true
        return isValid
    }

    /// Replaces the value and hides the error again, as for a new, untouched field.
    public mutating func reset(to value: Value) {
        self.value = value
        isEdited = false
        isChecked = false
    }
}

extension ValidatedValue: Sendable where Value: Sendable {}
