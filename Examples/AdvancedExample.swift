// AdvancedExample.swift
// SwiftUI-Components Examples
//
// Advanced examples demonstrating complex use cases

import SwiftUI
import SwiftUI_Components

// MARK: - Complete App Example

struct CompleteAppExample: View {
    @State private var selectedTab = 0
    @StateObject private var appState = AppState()
    
    var body: some View {
        CustomTabBar(
            selectedIndex: $selectedTab,
            tabs: AppTab.allCases.map { $0.tabItem }
        ) {
            TabView(selection: $selectedTab) {
                DashboardView()
                    .environmentObject(appState)
                    .tag(0)
                
                ProductListView()
                    .environmentObject(appState)
                    .tag(1)
                
                CartView()
                    .environmentObject(appState)
                    .tag(2)
                
                ProfileSettingsView()
                    .environmentObject(appState)
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

// MARK: - App State

class AppState: ObservableObject {
    @Published var cartItems: [Product] = []
    @Published var user: User?
    @Published var isLoading = false
    
    var cartBadge: Int? {
        cartItems.isEmpty ? nil : cartItems.count
    }
}

// MARK: - Models

struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var avatarURL: URL?
}

struct Product: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let price: Decimal
    let imageURL: URL?
    let category: String
    var isFavorite: Bool = false
}

// MARK: - Tab Configuration

enum AppTab: CaseIterable {
    case dashboard, products, cart, profile
    
    var tabItem: TabItem {
        switch self {
        case .dashboard:
            return TabItem(icon: Image(systemName: "square.grid.2x2"), title: "Dashboard", badge: nil)
        case .products:
            return TabItem(icon: Image(systemName: "bag"), title: "Products", badge: nil)
        case .cart:
            return TabItem(icon: Image(systemName: "cart"), title: "Cart", badge: 3)
        case .profile:
            return TabItem(icon: Image(systemName: "person"), title: "Profile", badge: nil)
        }
    }
}

// MARK: - Dashboard View

struct DashboardView: View {
    @EnvironmentObject private var appState: AppState
    
    let stats: [(title: String, value: String, trend: String, icon: String)] = [
        ("Revenue", "$12,450", "+12%", "dollarsign.circle"),
        ("Orders", "156", "+8%", "bag"),
        ("Customers", "2,340", "+15%", "person.2"),
        ("Products", "89", "+3%", "cube.box"),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Stats Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(stats, id: \.title) { stat in
                            StatCard(
                                title: stat.title,
                                value: stat.value,
                                trend: stat.trend,
                                icon: stat.icon
                            )
                        }
                    }
                    
                    // Recent Activity
                    Card {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Activity")
                                .font(.headline)
                            
                            ActivityTimeline()
                        }
                    }
                    
                    // Quick Actions
                    Card {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Quick Actions")
                                .font(.headline)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                QuickActionButton(icon: "plus", title: "Add Product")
                                QuickActionButton(icon: "arrow.up.doc", title: "Export")
                                QuickActionButton(icon: "chart.bar", title: "Analytics")
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .refreshable {
                await refreshData()
            }
        }
    }
    
    private func refreshData() async {
        // Simulate refresh
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let trend: String
    let icon: String
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.accentColor)
                    Spacer()
                    Text(trend)
                        .font(.caption)
                        .foregroundColor(.green)
                }
                
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ActivityTimeline: View {
    let activities: [(time: String, title: String, icon: String)] = [
        ("2m ago", "New order received", "bag.badge.plus"),
        ("15m ago", "Payment processed", "creditcard"),
        ("1h ago", "Customer signed up", "person.badge.plus"),
        ("2h ago", "Product updated", "cube.box"),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(activities, id: \.title) { activity in
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 8, height: 8)
                    
                    Image(systemName: activity.icon)
                        .foregroundColor(.secondary)
                    
                    Text(activity.title)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text(activity.time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                
                if activity.title != activities.last?.title {
                    Divider()
                        .padding(.leading, 20)
                }
            }
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    
    var body: some View {
        Button {
            // Action
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Product List View

struct ProductListView: View {
    @EnvironmentObject private var appState: AppState
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var isGridView = true
    
    let categories = ["All", "Electronics", "Clothing", "Home", "Sports"]
    
    let products: [Product] = [
        Product(id: UUID(), name: "Wireless Headphones", description: "Premium noise-canceling headphones", price: 299.99, imageURL: nil, category: "Electronics"),
        Product(id: UUID(), name: "Smart Watch", description: "Fitness tracking smartwatch", price: 399.99, imageURL: nil, category: "Electronics"),
        Product(id: UUID(), name: "Running Shoes", description: "Lightweight running shoes", price: 129.99, imageURL: nil, category: "Sports"),
        Product(id: UUID(), name: "Cotton T-Shirt", description: "Comfortable casual t-shirt", price: 29.99, imageURL: nil, category: "Clothing"),
    ]
    
    var filteredProducts: [Product] {
        products.filter { product in
            let matchesSearch = searchText.isEmpty || product.name.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory == "All" || product.category == selectedCategory
            return matchesSearch && matchesCategory
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search and Filter
                VStack(spacing: 12) {
                    SearchBar(text: $searchText, placeholder: "Search products...")
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { category in
                                Chip(
                                    title: category,
                                    isSelected: selectedCategory == category
                                ) {
                                    selectedCategory = category
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Products
                if isGridView {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(filteredProducts) { product in
                                ProductCard(product: product)
                            }
                        }
                        .padding()
                    }
                } else {
                    List(filteredProducts) { product in
                        ProductRow(product: product)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            isGridView.toggle()
                        }
                    } label: {
                        Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                    }
                }
            }
        }
    }
}

struct ProductCard: View {
    let product: Product
    @State private var isFavorite = false
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 8) {
                // Image placeholder
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.secondary.opacity(0.1))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.secondary)
                    }
                
                Text(product.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(product.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                    
                    Spacer()
                    
                    IconButton(
                        icon: Image(systemName: isFavorite ? "heart.fill" : "heart"),
                        size: 32,
                        backgroundColor: .clear
                    ) {
                        isFavorite.toggle()
                    }
                }
            }
        }
    }
}

struct ProductRow: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.1))
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                Text(product.category)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("$\(product.price, specifier: "%.2f")")
                .fontWeight(.semibold)
        }
    }
}

// MARK: - Cart View

struct CartView: View {
    @EnvironmentObject private var appState: AppState
    @State private var promoCode = ""
    
    var body: some View {
        NavigationStack {
            if appState.cartItems.isEmpty {
                EmptyCartView()
            } else {
                CartContentView()
            }
        }
    }
}

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "cart")
                .font(.system(size: 80))
                .foregroundColor(.secondary)
            
            Text("Your cart is empty")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Browse products and add items to your cart")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            PrimaryButton(title: "Start Shopping") {
                // Navigate to products
            }
        }
        .padding()
        .navigationTitle("Cart")
    }
}

struct CartContentView: View {
    var body: some View {
        VStack {
            List {
                ForEach(0..<3) { _ in
                    CartItemRow()
                }
                .onDelete { _ in }
            }
            .listStyle(.plain)
            
            // Summary
            Card {
                VStack(spacing: 12) {
                    HStack {
                        Text("Subtotal")
                        Spacer()
                        Text("$829.97")
                    }
                    HStack {
                        Text("Shipping")
                        Spacer()
                        Text("$9.99")
                    }
                    Divider()
                    HStack {
                        Text("Total")
                            .fontWeight(.bold)
                        Spacer()
                        Text("$839.96")
                            .fontWeight(.bold)
                    }
                    
                    PrimaryButton(title: "Checkout") {
                        // Checkout
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Cart")
    }
}

struct CartItemRow: View {
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.1))
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Product Name")
                    .font(.headline)
                Text("$299.99")
                    .foregroundColor(.accentColor)
            }
            
            Spacer()
            
            Stepper("", value: .constant(1), in: 1...10)
                .labelsHidden()
        }
    }
}

// MARK: - Profile Settings View

struct ProfileSettingsView: View {
    @EnvironmentObject private var appState: AppState
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var biometricEnabled = true
    
    var body: some View {
        NavigationStack {
            List {
                // Profile Section
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.accentColor.gradient)
                            .frame(width: 60, height: 60)
                            .overlay {
                                Text("MC")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Muhittin Camdali")
                                .font(.headline)
                            Text("muhittin@example.com")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Preferences
                Section("Preferences") {
                    StyledToggle(isOn: $notificationsEnabled, label: "Notifications")
                    StyledToggle(isOn: $darkModeEnabled, label: "Dark Mode")
                    StyledToggle(isOn: $biometricEnabled, label: "Face ID / Touch ID")
                }
                
                // Account
                Section("Account") {
                    NavigationLink("Payment Methods") { Text("Payment Methods") }
                    NavigationLink("Addresses") { Text("Addresses") }
                    NavigationLink("Order History") { Text("Order History") }
                }
                
                // Support
                Section("Support") {
                    NavigationLink("Help Center") { Text("Help Center") }
                    NavigationLink("Privacy Policy") { Text("Privacy Policy") }
                    NavigationLink("Terms of Service") { Text("Terms of Service") }
                }
                
                // Logout
                Section {
                    Button(role: .destructive) {
                        // Logout
                    } label: {
                        HStack {
                            Spacer()
                            Text("Log Out")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

// MARK: - Preview

#Preview {
    CompleteAppExample()
}
