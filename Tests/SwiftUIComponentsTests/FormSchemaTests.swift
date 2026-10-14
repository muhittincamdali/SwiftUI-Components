import Foundation
import Testing
@testable import SwiftUIComponents

@Suite("FormSchema")
struct FormSchemaTests {
    private let json = Data("""
    {
      "title": "Sign up",
      "fields": [
        { "id": "name", "label": "Name", "required": true, "maxLength": 20 },
        { "id": "email", "label": "Email", "kind": "email", "required": true },
        { "id": "site", "label": "Website", "kind": "url" },
        { "id": "age", "label": "Age", "kind": "number", "minimum": 18, "maximum": 120 },
        { "id": "plan", "label": "Plan", "kind": "choice", "options": ["Free", "Pro"], "required": true },
        { "id": "code", "label": "Code", "pattern": "[A-Z]{3}-[0-9]{3}", "patternMessage": "Use ABC-123" },
        { "id": "terms", "label": "I accept the terms", "kind": "toggle", "required": true }
      ]
    }
    """.utf8)

    @Test func decodesWithDefaults() throws {
        let schema = try FormSchema.decode(from: json)
        #expect(schema.title == "Sign up")
        #expect(schema.fields.map(\.id) == ["name", "email", "site", "age", "plan", "code", "terms"])
        #expect(schema.fields[0].kind == .text)
        #expect(schema.fields[0].isRequired)
        #expect(schema.fields[2].isRequired == false)
        #expect(schema.fields[4].options == ["Free", "Pro"])
    }

    @Test func rejectsUnknownKinds() {
        let data = Data(#"{"fields":[{"id":"a","label":"A","kind":"slider"}]}"#.utf8)
        #expect(throws: DecodingError.self) { try FormSchema.decode(from: data) }
    }

    @Test func rejectsSchemasThatCannotBeRendered() {
        let duplicate = FormSchema(fields: [.init(id: "a", label: "A"), .init(id: "a", label: "B")])
        #expect(throws: FormSchema.SchemaError.duplicateID("a")) { try duplicate.check() }

        let noOptions = FormSchema(fields: [.init(id: "plan", label: "Plan", kind: .choice, options: [])])
        #expect(throws: FormSchema.SchemaError.missingOptions("plan")) { try noOptions.check() }

        let badPattern = FormSchema(fields: [.init(id: "code", label: "Code", pattern: "(")])
        #expect(throws: FormSchema.SchemaError.invalidPattern("code")) { try badPattern.check() }
    }

    @Test func initialValuesLeaveNumbersAndChoicesUnset() throws {
        let values = try FormSchema.decode(from: json).initialValues()
        #expect(values["name"] == .text(""))
        #expect(values["terms"] == .bool(false))
        #expect(values["age"] == nil)
        #expect(values["plan"] == nil)
    }

    @Test func emptyFormReportsOnlyRequiredFields() throws {
        let schema = try FormSchema.decode(from: json)
        let errors = schema.errors(in: schema.initialValues())
        #expect(Set(errors.keys) == ["name", "email", "plan", "terms"])
        #expect(errors["terms"] == "Turn this on to continue")
        #expect(errors["plan"] == "Choose an option")
    }

    @Test func validFormHasNoErrors() throws {
        let schema = try FormSchema.decode(from: json)
        let values: [String: FormValue] = [
            "name": .text("Ada"),
            "email": .text("ada@example.com"),
            "site": .text(""),
            "age": .number(36),
            "plan": .text("Pro"),
            "code": .text("ABC-123"),
            "terms": .bool(true),
        ]
        #expect(schema.errors(in: values).isEmpty)
    }

    @Test func eachRuleReportsItsField() throws {
        let schema = try FormSchema.decode(from: json)
        var values = schema.initialValues()
        values["name"] = .text(String(repeating: "a", count: 21))
        values["email"] = .text("ada@")
        values["site"] = .text("example.com")
        values["age"] = .number(17)
        values["plan"] = .text("Enterprise")
        values["code"] = .text("abc-123")
        values["terms"] = .bool(true)

        let errors = schema.errors(in: values)
        #expect(errors["name"] == "Use at most 20 characters")
        #expect(errors["email"] == "Enter a valid email address")
        #expect(errors["site"] == "Enter a valid web address")
        #expect(errors["age"] != nil)
        #expect(errors["plan"] == "Choose one of the listed options")
        #expect(errors["code"] == "Use ABC-123")
        #expect(errors["terms"] == nil)

        values["age"] = .number(121)
        #expect(schema.errors(in: values)["age"] != nil)
        values["age"] = .number(120)
        #expect(schema.errors(in: values)["age"] == nil)
    }

    @Test func valuesEncodeAsPlainJSON() throws {
        let values: [String: FormValue] = ["name": .text("Ada"), "age": .number(36), "terms": .bool(true)]
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(values)
        #expect(String(decoding: data, as: UTF8.self) == #"{"age":36,"name":"Ada","terms":true}"#)
        #expect(try JSONDecoder().decode([String: FormValue].self, from: data) == values)
    }

    @Test func schemaRoundTripsThroughJSON() throws {
        let schema = try FormSchema.decode(from: json)
        let reencoded = try JSONEncoder().encode(schema)
        #expect(try FormSchema.decode(from: reencoded) == schema)
    }
}
