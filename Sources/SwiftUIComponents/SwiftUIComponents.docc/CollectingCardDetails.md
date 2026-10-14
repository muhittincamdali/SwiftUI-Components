# Collecting Card Details

Build a payment form with ``CreditCardInput`` and enable the pay button only when every field
is valid.

## Overview

``CreditCardInput`` is four text fields (number, expiry, security code, cardholder name) with a
card preview on top. It formats what the user types, detects the card network from the first
digits and reports through a callback whether the whole form is valid. It does not send or
store anything: the values live in the bindings you pass in.

## Build the form

Keep one `@State` string per field and a flag for the pay button. `onValidationChange` is
called after each edit with `true` when all four fields are valid:

```swift
import SwiftUI
import SwiftUIComponents

struct PaymentForm: View {
    @State private var number = ""
    @State private var expiry = ""
    @State private var cvv = ""
    @State private var name = ""
    @State private var canPay = false

    var body: some View {
        VStack {
            CreditCardInput(
                cardNumber: $number,
                expiryDate: $expiry,
                cvv: $cvv,
                cardholderName: $name,
                onValidationChange: { canPay = $0 }
            )
            PrimaryButton("Pay", isDisabled: !canPay) {}
        }
        .padding()
    }
}
```

Pass `showCardPreview: false` to hide the card drawing, and `accentColor` or `errorColor` to
match your app's colors.

## What counts as valid

| Field           | Rule                                                                                                         |
| --------------- | ------------------------------------------------------------------------------------------------------------ |
| Card number     | As many digits as the detected network uses (16, American Express 15, Diners Club 14) and a valid Luhn check |
| Expiry          | `MM/YY` with a month from 01 to 12, not before the current month                                             |
| Security code   | 3 digits, 4 for American Express                                                                             |
| Cardholder name | At least 2 characters                                                                                        |

The network comes from the leading digits: 4 is Visa, 34 and 37 American Express, 51–55 and
2221–2720 Mastercard, 6011 and 65 Discover, 300–305, 36, 38 and 39 Diners Club, 35 JCB. The
number is grouped the way the network prints it: 4-4-4-4, 4-6-5 for American Express and
4-6-4 for Diners Club.

A field shows an error only when there is something wrong to report, for example a full-length
number that fails the Luhn check or an expired date. A field that is still being typed stays
neutral.

## Use the checks without the view

The same rules are public static functions, so you can check a number that came from somewhere
else, such as a saved card or a pasted value:

```swift
let type = CreditCardInput.CardType.detect(from: "3782 822463 10005") // .amex
let pretty = CreditCardInput.formatCardNumber("378282246310005")     // "3782 822463 10005"
let valid = CreditCardInput.isLuhnValid("378282246310005")           // true
let expiry = CreditCardInput.checkExpiry("12/30")                    // .valid
```

``CreditCardInput/checkExpiry(_:now:calendar:)`` takes the date and calendar as parameters, so
tests can pin the current month.

## Handle the data with care

These checks catch typing mistakes; they do not tell you whether a card can be charged. Only
your payment provider can. Send the values to the provider's SDK or API and do not log or
persist the bound strings yourself. The component does not make network requests, write to
disk or print what the user types.

## See Also

- ``CreditCardInput``
- ``PhoneInput``
- ``PinInput``
