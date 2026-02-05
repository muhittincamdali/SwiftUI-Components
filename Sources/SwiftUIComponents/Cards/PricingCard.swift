import SwiftUI

/// A card for displaying pricing tiers
public struct PricingCard: View {
    let name: String
    let price: String
    let period: String
    let description: String?
    let features: [Feature]
    let isPopular: Bool
    let buttonTitle: String
    let color: Color
    let onSelect: () -> Void
    
    public struct Feature: Identifiable {
        public let id = UUID()
        let text: String
        let isIncluded: Bool
        
        public init(_ text: String, included: Bool = true) {
            self.text = text
            self.isIncluded = included
        }
    }
    
    public init(
        name: String,
        price: String,
        period: String = "/month",
        description: String? = nil,
        features: [Feature],
        isPopular: Bool = false,
        buttonTitle: String = "Get Started",
        color: Color = .accentColor,
        onSelect: @escaping () -> Void
    ) {
        self.name = name
        self.price = price
        self.period = period
        self.description = description
        self.features = features
        self.isPopular = isPopular
        self.buttonTitle = buttonTitle
        self.color = color
        self.onSelect = onSelect
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                if isPopular {
                    Text("MOST POPULAR")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(color)
                        .cornerRadius(4)
                }
                
                Text(name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isPopular ? .white : .primary)
                
                HStack(alignment: .bottom, spacing: 2) {
                    Text(price)
                        .font(.system(size: 36, weight: .bold))
                    Text(period)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .padding(.bottom, 6)
                }
                .foregroundColor(isPopular ? .white : .primary)
                
                if let description = description {
                    Text(description)
                        .font(.system(size: 13))
                        .foregroundColor(isPopular ? .white.opacity(0.8) : .secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(isPopular ? color : Color(.systemGray6))
            
            // Features
            VStack(alignment: .leading, spacing: 12) {
                ForEach(features) { feature in
                    HStack(spacing: 10) {
                        Image(systemName: feature.isIncluded ? "checkmark.circle.fill" : "xmark.circle")
                            .foregroundColor(feature.isIncluded ? .green : .gray)
                            .font(.system(size: 18))
                        
                        Text(feature.text)
                            .font(.system(size: 14))
                            .foregroundColor(feature.isIncluded ? .primary : .secondary)
                    }
                }
            }
            .padding(20)
            
            // Button
            Button(action: onSelect) {
                Text(buttonTitle)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isPopular ? color : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(isPopular ? Color.white : color)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isPopular ? color : Color.clear, lineWidth: 2)
        )
        .shadow(color: isPopular ? color.opacity(0.3) : .black.opacity(0.08), radius: isPopular ? 15 : 10, x: 0, y: 4)
    }
}

/// Horizontal pricing comparison
public struct PricingToggle: View {
    @Binding var isAnnual: Bool
    let monthlyLabel: String
    let annualLabel: String
    let discount: String?
    
    public init(
        isAnnual: Binding<Bool>,
        monthlyLabel: String = "Monthly",
        annualLabel: String = "Annual",
        discount: String? = "Save 20%"
    ) {
        self._isAnnual = isAnnual
        self.monthlyLabel = monthlyLabel
        self.annualLabel = annualLabel
        self.discount = discount
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Text(monthlyLabel)
                .font(.system(size: 14, weight: isAnnual ? .regular : .semibold))
                .foregroundColor(isAnnual ? .secondary : .primary)
            
            Toggle("", isOn: $isAnnual)
                .labelsHidden()
                .tint(.accentColor)
            
            HStack(spacing: 6) {
                Text(annualLabel)
                    .font(.system(size: 14, weight: isAnnual ? .semibold : .regular))
                    .foregroundColor(isAnnual ? .primary : .secondary)
                
                if let discount = discount, isAnnual {
                    Text(discount)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green)
                        .cornerRadius(4)
                }
            }
        }
    }
}

#Preview("Pricing Cards") {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 16) {
            PricingCard(
                name: "Basic",
                price: "$9",
                description: "Perfect for individuals",
                features: [
                    .init("5 Projects"),
                    .init("10GB Storage"),
                    .init("Email Support"),
                    .init("API Access", included: false),
                    .init("Custom Domain", included: false)
                ],
                onSelect: {}
            )
            .frame(width: 280)
            
            PricingCard(
                name: "Pro",
                price: "$29",
                description: "Best for professionals",
                features: [
                    .init("Unlimited Projects"),
                    .init("100GB Storage"),
                    .init("Priority Support"),
                    .init("API Access"),
                    .init("Custom Domain", included: false)
                ],
                isPopular: true,
                color: .purple,
                onSelect: {}
            )
            .frame(width: 280)
            
            PricingCard(
                name: "Enterprise",
                price: "$99",
                description: "For large teams",
                features: [
                    .init("Unlimited Projects"),
                    .init("Unlimited Storage"),
                    .init("24/7 Support"),
                    .init("API Access"),
                    .init("Custom Domain")
                ],
                color: .blue,
                onSelect: {}
            )
            .frame(width: 280)
        }
        .padding()
    }
    .background(Color(.systemGray6))
}
