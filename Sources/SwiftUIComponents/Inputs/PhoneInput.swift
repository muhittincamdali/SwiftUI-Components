import SwiftUI

/// A phone number input with country code picker and formatting.
///
/// `PhoneInput` provides automatic phone number formatting
/// and country code selection with flags.
///
/// ```swift
/// PhoneInput(phoneNumber: $phone, countryCode: $country)
/// ```
public struct PhoneInput: View {
    // MARK: - Types
    
    /// Country information for phone codes.
    public struct Country: Identifiable, Hashable {
        public let id: String
        public let name: String
        public let dialCode: String
        public let flag: String
        public let format: String
        
        public init(id: String, name: String, dialCode: String, flag: String, format: String = "") {
            self.id = id
            self.name = name
            self.dialCode = dialCode
            self.flag = flag
            self.format = format
        }
        
        public static let defaultCountries: [Country] = [
            Country(id: "US", name: "United States", dialCode: "+1", flag: "🇺🇸", format: "(###) ###-####"),
            Country(id: "GB", name: "United Kingdom", dialCode: "+44", flag: "🇬🇧", format: "#### ######"),
            Country(id: "DE", name: "Germany", dialCode: "+49", flag: "🇩🇪", format: "### ########"),
            Country(id: "FR", name: "France", dialCode: "+33", flag: "🇫🇷", format: "# ## ## ## ##"),
            Country(id: "TR", name: "Turkey", dialCode: "+90", flag: "🇹🇷", format: "### ### ## ##"),
            Country(id: "JP", name: "Japan", dialCode: "+81", flag: "🇯🇵", format: "##-####-####"),
            Country(id: "CN", name: "China", dialCode: "+86", flag: "🇨🇳", format: "### #### ####"),
            Country(id: "IN", name: "India", dialCode: "+91", flag: "🇮🇳", format: "##### #####"),
            Country(id: "BR", name: "Brazil", dialCode: "+55", flag: "🇧🇷", format: "## #####-####"),
            Country(id: "AU", name: "Australia", dialCode: "+61", flag: "🇦🇺", format: "### ### ###"),
            Country(id: "CA", name: "Canada", dialCode: "+1", flag: "🇨🇦", format: "(###) ###-####"),
            Country(id: "MX", name: "Mexico", dialCode: "+52", flag: "🇲🇽", format: "## #### ####"),
            Country(id: "IT", name: "Italy", dialCode: "+39", flag: "🇮🇹", format: "### ### ####"),
            Country(id: "ES", name: "Spain", dialCode: "+34", flag: "🇪🇸", format: "### ### ###"),
            Country(id: "RU", name: "Russia", dialCode: "+7", flag: "🇷🇺", format: "### ###-##-##"),
        ]
    }
    
    // MARK: - Properties
    
    @Binding private var phoneNumber: String
    @Binding private var selectedCountry: Country
    private let countries: [Country]
    private let placeholder: String
    private let borderColor: Color
    private let focusedBorderColor: Color
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let showFlag: Bool
    private let autoFormat: Bool
    private let onValidation: ((Bool) -> Void)?
    
    @State private var showCountryPicker: Bool = false
    @State private var searchText: String = ""
    @FocusState private var isFocused: Bool
    
    // MARK: - Initialization
    
    /// Creates a new phone input.
    public init(
        phoneNumber: Binding<String>,
        selectedCountry: Binding<Country>,
        countries: [Country] = Country.defaultCountries,
        placeholder: String = "Phone number",
        borderColor: Color = .gray.opacity(0.3),
        focusedBorderColor: Color = .blue,
        backgroundColor: Color = Color(.systemBackground),
        cornerRadius: CGFloat = 12,
        showFlag: Bool = true,
        autoFormat: Bool = true,
        onValidation: ((Bool) -> Void)? = nil
    ) {
        self._phoneNumber = phoneNumber
        self._selectedCountry = selectedCountry
        self.countries = countries
        self.placeholder = placeholder
        self.borderColor = borderColor
        self.focusedBorderColor = focusedBorderColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.showFlag = showFlag
        self.autoFormat = autoFormat
        self.onValidation = onValidation
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 0) {
            // Country code button
            Button {
                showCountryPicker = true
            } label: {
                HStack(spacing: 6) {
                    if showFlag {
                        Text(selectedCountry.flag)
                            .font(.title3)
                    }
                    
                    Text(selectedCountry.dialCode)
                        .font(.body)
                        .foregroundStyle(.primary)
                    
                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .background(Color(.systemGray6))
            }
            .buttonStyle(.plain)
            
            // Divider
            Rectangle()
                .fill(isFocused ? focusedBorderColor : borderColor)
                .frame(width: 1)
            
            // Phone number field
            TextField(placeholder, text: $phoneNumber)
                .keyboardType(.phonePad)
                .focused($isFocused)
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .onChange(of: phoneNumber) { _, newValue in
                    if autoFormat {
                        phoneNumber = formatPhoneNumber(newValue)
                    }
                    validatePhone()
                }
        }
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(isFocused ? focusedBorderColor : borderColor, lineWidth: isFocused ? 2 : 1)
        )
        .sheet(isPresented: $showCountryPicker) {
            countryPickerSheet
        }
    }
    
    // MARK: - Country Picker Sheet
    
    private var countryPickerSheet: some View {
        NavigationStack {
            List {
                ForEach(filteredCountries) { country in
                    Button {
                        selectedCountry = country
                        showCountryPicker = false
                    } label: {
                        HStack {
                            Text(country.flag)
                                .font(.title2)
                            
                            Text(country.name)
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            Text(country.dialCode)
                                .foregroundStyle(.secondary)
                            
                            if country.id == selectedCountry.id {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search countries")
            .navigationTitle("Select Country")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showCountryPicker = false
                    }
                }
            }
        }
    }
    
    // MARK: - Filtering
    
    private var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countries
        }
        return countries.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.dialCode.contains(searchText)
        }
    }
    
    // MARK: - Formatting
    
    private func formatPhoneNumber(_ number: String) -> String {
        let digits = number.filter { $0.isNumber }
        let format = selectedCountry.format
        
        guard !format.isEmpty else {
            return digits
        }
        
        var result = ""
        var digitIndex = digits.startIndex
        
        for char in format {
            guard digitIndex < digits.endIndex else { break }
            
            if char == "#" {
                result.append(digits[digitIndex])
                digitIndex = digits.index(after: digitIndex)
            } else {
                result.append(char)
            }
        }
        
        // Append remaining digits if format is exhausted
        if digitIndex < digits.endIndex {
            result.append(contentsOf: digits[digitIndex...])
        }
        
        return result
    }
    
    // MARK: - Validation
    
    private func validatePhone() {
        let digits = phoneNumber.filter { $0.isNumber }
        let isValid = digits.count >= 7 && digits.count <= 15
        onValidation?(isValid)
    }
}

// MARK: - Compact Phone Input

/// A more compact phone input variant.
public struct CompactPhoneInput: View {
    @Binding var fullNumber: String
    let placeholder: String
    
    @State private var selectedCountry: PhoneInput.Country = .defaultCountries[0]
    @State private var localNumber: String = ""
    
    public init(fullNumber: Binding<String>, placeholder: String = "Phone") {
        self._fullNumber = fullNumber
        self.placeholder = placeholder
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            Menu {
                ForEach(PhoneInput.Country.defaultCountries) { country in
                    Button {
                        selectedCountry = country
                        updateFullNumber()
                    } label: {
                        Text("\(country.flag) \(country.dialCode)")
                    }
                }
            } label: {
                Text("\(selectedCountry.flag) \(selectedCountry.dialCode)")
                    .font(.subheadline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            TextField(placeholder, text: $localNumber)
                .keyboardType(.phonePad)
                .onChange(of: localNumber) { _, _ in
                    updateFullNumber()
                }
        }
    }
    
    private func updateFullNumber() {
        let digits = localNumber.filter { $0.isNumber }
        fullNumber = selectedCountry.dialCode + digits
    }
}

// MARK: - Phone Display

/// A formatted phone number display view.
public struct PhoneDisplay: View {
    let phoneNumber: String
    let showCallButton: Bool
    let onCall: (() -> Void)?
    
    public init(
        phoneNumber: String,
        showCallButton: Bool = true,
        onCall: (() -> Void)? = nil
    ) {
        self.phoneNumber = phoneNumber
        self.showCallButton = showCallButton
        self.onCall = onCall
    }
    
    public var body: some View {
        HStack {
            Text(phoneNumber)
                .font(.body.monospacedDigit())
            
            if showCallButton {
                Spacer()
                
                Button {
                    onCall?()
                } label: {
                    Image(systemName: "phone.fill")
                        .foregroundStyle(.green)
                        .padding(8)
                        .background(Color.green.opacity(0.1))
                        .clipShape(Circle())
                }
            }
        }
    }
}

#if DEBUG
struct PhoneInputPreview: View {
    @State private var phone1 = ""
    @State private var country1 = PhoneInput.Country.defaultCountries[0]
    @State private var phone2 = ""
    @State private var isValid = false
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(alignment: .leading) {
                Text("Standard Phone Input")
                    .font(.caption)
                PhoneInput(
                    phoneNumber: $phone1,
                    selectedCountry: $country1,
                    onValidation: { isValid = $0 }
                )
                Text(isValid ? "✓ Valid" : "Enter phone number")
                    .font(.caption)
                    .foregroundStyle(isValid ? .green : .secondary)
            }
            
            VStack(alignment: .leading) {
                Text("Compact Input")
                    .font(.caption)
                CompactPhoneInput(fullNumber: $phone2)
            }
            
            VStack(alignment: .leading) {
                Text("Phone Display")
                    .font(.caption)
                PhoneDisplay(phoneNumber: "+1 (555) 123-4567")
            }
        }
        .padding()
    }
}

#Preview {
    PhoneInputPreview()
}
#endif
