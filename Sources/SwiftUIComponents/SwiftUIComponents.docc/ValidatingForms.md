# Validating Forms

Check what the user types with reusable validators, build a form from JSON your server sends,
and split a long form into steps.

## Overview

A `Validator` checks one kind of value and returns a `ValidationResult`. Combine the
built-in validators with `Validator/and(_:)`, wrap a value and its validator in a
`ValidatedValue` so errors appear only after the user edits the field or taps submit, and use
`AsyncValidation` for checks that need the network. `FormSchema` and `SchemaForm` render a
whole form from data, and `MultiStepForm` walks the user through several screens.

## Validate a field

Every validator except `required` accepts an empty value, so an optional field only complains
once the user types something:

```swift
let email: Validator<String> = .required().and(.email())
email.validate("")             // .invalid("This field is required")
email.validate("ada@example")  // .invalid("Enter a valid email address")
email.validate("ada@example.com").isValid // true
```

Text validators: `required`, `minLength`, `maxLength`, `email`, `url`, `phone`, `digits`,
`matches` (a regular expression) and `equals`. For `Comparable` values there are `range`,
`atLeast` and `atMost`; for collections, `notEmpty` and `count`. Pass your own message to any of
them, or write a rule with `Validator/custom(_:_:)`.

## Show errors at the right time

An error under a field the user has not touched yet is noise. `ValidatedValue` reports
`ValidatedValue/visibleError` only after the value changes or `ValidatedValue/validate()`
runs, which the submit button does for every field:

```swift
struct SignUpForm: View {
    @State private var email = ValidatedValue("", .required().and(.email()))
    @State private var password = ValidatedValue("", .required().and(.minLength(8)))

    var body: some View {
        VStack(spacing: 16) {
            FormField(label: "Email", errorMessage: email.visibleError) {
                TextInputField(text: $email.value, placeholder: "you@example.com", keyboardType: .email)
            }
            FormField(label: "Password", errorMessage: password.visibleError) {
                PasswordField(password: $password.value)
            }
            PrimaryButton("Create account") {
                let emailIsValid = email.validate()     // shows the errors of untouched fields
                let passwordIsValid = password.validate()
                if emailIsValid && passwordIsValid {
                    print("Signing up \(email.value)")
                }
            }
        }
        .padding()
    }
}
```

## Check a value on the server

`AsyncValidation` waits for a pause in typing (400 ms by default), runs your check, and keeps
only the answer for the latest value, so a slow reply for `"ad"` cannot overwrite the reply for
`"ada"`:

```swift
@State private var username = AsyncValidation<String> { name in
    try await api.isAvailable(name) ? .valid : .invalid("That name is taken")
}

TextInputField(text: $name, placeholder: "Username")
    .task(id: name) { await username.validate(name) }
```

A thrown error becomes `AsyncValidation/State/failed(_:)`, so the form can tell "taken" from
"could not check".

## Build a form from JSON

Describe the fields as data and let `SchemaForm` render them with the package's inputs:

```swift
let contactFormJSON = """
{
  "title": "Contact us",
  "fields": [
    { "id": "email", "label": "Email", "kind": "email", "required": true },
    { "id": "topic", "label": "Topic", "kind": "choice", "options": ["Sales", "Support"], "required": true },
    { "id": "message", "label": "Message", "kind": "multiline", "minLength": 10 }
  ]
}
"""

let schema = try FormSchema.decode(from: Data(contactFormJSON.utf8))
```

Keep the values in your own state, start them with `FormSchema/initialValues()`, and ask
`FormSchema/errors(in:)` before you submit. The values encode as a plain JSON object such as
`{"email": "ada@example.com", "topic": "Sales"}`.

### Treat a schema from the network as untrusted

`FormSchema/decode(from:)` runs `FormSchema/check()`, which rejects duplicate ids, choice
fields without options, impossible limits and invalid regular expressions. It also rejects
patterns that could freeze the app: Swift's `Regex` backtracks and cannot be interrupted, so a
pattern such as `(a|a)+` takes minutes on a 30-character value. `check()` throws
`FormSchema/SchemaError/unsafePattern(_:)` for a group that can repeat and match the same
text in more than one way, for long chains of open-ended repetitions, and for syntax it does
not model (`\Q…\E`, `(?#…)`, the `x` option). Some harmless patterns, such as `(cat|dog)+`, are
rejected too.

If a schema reaches the form without `check()`, for example through `JSONDecoder` directly, an
unsafe pattern fails every non-empty value instead of running, and values longer than 256
characters never reach a pattern.

## Split a form into steps

`StepFlow` tracks the current step and which steps are complete; `MultiStepForm` shows a
step indicator and Back and Next buttons, and keeps Next disabled while `canAdvance` returns
`false`:

```swift
@State private var flow = StepFlow(count: 2)

MultiStepForm(
    flow: $flow,
    steps: [.init(title: "Account"), .init(title: "Profile")],
    canAdvance: { step in step == 0 ? email.isValid : name.isValid },
    onFinish: { submit() }
) { step in
    if step == 0 { AccountStep(email: $email) } else { ProfileStep(name: $name) }
}
```

If you build your own step list that the user can tap, ``StepFlow/jump(to:)`` moves only to a
step whose earlier steps are all complete, so a tap cannot skip an unfinished step.

## What the checks do not cover

`email` and `phone` check the format only. The only way to know that an address or a number
exists is to send it a message. Validate again on your server: the checks here help the user,
they do not protect your backend.
