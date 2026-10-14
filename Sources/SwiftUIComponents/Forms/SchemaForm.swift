import SwiftUI

/// Renders a ``FormSchema`` with the package's form fields and shows each field's validation
/// error once the user has edited it.
///
/// Keep the values in your own state so you can submit them; ``FormSchema/errors(in:)`` tells
/// you whether they are valid. Set `showsAllErrors` to `true` after a failed submit to reveal
/// the errors of fields the user has not touched.
///
/// ```swift
/// @State private var values = schema.initialValues()
/// @State private var submitted = false
///
/// SchemaForm(schema: schema, values: $values, showsAllErrors: submitted)
/// PrimaryButton("Send") {
///     submitted = true
///     if schema.errors(in: values).isEmpty { send(values) }
/// }
/// ```
public struct SchemaForm: View {
    private let schema: FormSchema
    @Binding private var values: [String: FormValue]
    private let showsAllErrors: Bool
    @State private var edited: Set<String> = []

    /// Creates a form for `schema` that reads and writes `values`.
    public init(schema: FormSchema, values: Binding<[String: FormValue]>, showsAllErrors: Bool = false) {
        self.schema = schema
        self._values = values
        self.showsAllErrors = showsAllErrors
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            if let title = schema.title {
                Text(title)
                    .font(.title2.bold())
                    .accessibilityAddTraits(.isHeader)
            }
            ForEach(schema.fields) { field in
                row(for: field)
            }
        }
    }

    @ViewBuilder
    private func row(for field: FormSchema.Field) -> some View {
        if field.kind == .toggle {
            VStack(alignment: .leading, spacing: 6) {
                Toggle(field.label, isOn: boolBinding(field.id))
                if let error = visibleError(for: field) {
                    Label(error, systemImage: "exclamationmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.red)
                } else if let help = field.help {
                    Text(help).font(.caption).foregroundStyle(.secondary)
                }
            }
        } else {
            FormField(
                label: field.label,
                helperText: field.help,
                errorMessage: visibleError(for: field),
                isRequired: field.isRequired
            ) {
                control(for: field)
            }
        }
    }

    @ViewBuilder
    private func control(for field: FormSchema.Field) -> some View {
        let placeholder = field.placeholder ?? ""
        switch field.kind {
        case .password:
            PasswordField(password: textBinding(field.id), placeholder: placeholder)
        case .multiline:
            TextAreaField(text: textBinding(field.id), placeholder: placeholder)
        case .number:
            TextField(placeholder, value: numberBinding(field.id), format: .number)
                .keyboard(.decimal)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.platformGray4))
        case .choice:
            Picker(field.label, selection: choiceBinding(field.id)) {
                Text(placeholder.isEmpty ? "Select" : placeholder).tag(String?.none)
                ForEach(field.options ?? [], id: \.self) { option in
                    Text(option).tag(Optional(option))
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
        default:
            TextInputField(text: textBinding(field.id), placeholder: placeholder, keyboardType: keyboard(for: field.kind))
        }
    }

    private func keyboard(for kind: FormSchema.Kind) -> KeyboardKind {
        switch kind {
        case .email: .email
        case .phone: .phone
        case .url: .url
        default: .standard
        }
    }

    private func visibleError(for field: FormSchema.Field) -> String? {
        guard showsAllErrors || edited.contains(field.id) else { return nil }
        return field.error(for: values[field.id])
    }

    private func update(_ id: String, to value: FormValue?) {
        values[id] = value
        edited.insert(id)
    }

    private func textBinding(_ id: String) -> Binding<String> {
        Binding(get: { values[id]?.text ?? "" }, set: { update(id, to: .text($0)) })
    }

    private func boolBinding(_ id: String) -> Binding<Bool> {
        Binding(get: { values[id]?.bool ?? false }, set: { update(id, to: .bool($0)) })
    }

    private func numberBinding(_ id: String) -> Binding<Double?> {
        Binding(get: { values[id]?.number }, set: { update(id, to: $0.map(FormValue.number)) })
    }

    private func choiceBinding(_ id: String) -> Binding<String?> {
        Binding(get: { values[id]?.text }, set: { update(id, to: $0.map(FormValue.text)) })
    }
}
