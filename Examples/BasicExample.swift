// BasicExample.swift
// SwiftUI-Components Examples
//
// A basic example demonstrating core components

import SwiftUI
import SwiftUI_Components

// MARK: - Basic Button Example

struct ButtonExampleView: View {
    @State private var isLoading = false
    @State private var showToast = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Primary Button
            PrimaryButton(title: "Submit Form") {
                submitForm()
            }
            
            // Secondary Button
            SecondaryButton(title: "Cancel", style: .outlined) {
                cancel()
            }
            
            // Ghost Button
            GhostButton(title: "Learn More") {
                showDetails()
            }
            
            // Icon Button
            IconButton(icon: Image(systemName: "heart.fill")) {
                toggleFavorite()
            }
            
            // Loading Button
            PrimaryButton(
                title: "Processing",
                isLoading: isLoading
            ) {
                processWithLoading()
            }
        }
        .padding()
        .toast(isPresented: $showToast, message: "Action completed!")
    }
    
    private func submitForm() {
        showToast = true
    }
    
    private func cancel() {
        // Handle cancel
    }
    
    private func showDetails() {
        // Show details
    }
    
    private func toggleFavorite() {
        // Toggle favorite
    }
    
    private func processWithLoading() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            showToast = true
        }
    }
}

// MARK: - Basic Card Example

struct CardExampleView: View {
    @State private var isExpanded = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Standard Card
                Card {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Standard Card")
                            .font(.headline)
                        Text("This is a basic card with default styling.")
                            .foregroundColor(.secondary)
                    }
                }
                
                // Expandable Card
                ExpandableCard(isExpanded: $isExpanded) {
                    HStack {
                        Text("Expandable Card")
                            .font(.headline)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    }
                } content: {
                    Text("This content is revealed when the card is expanded. You can put any content here including other components.")
                        .foregroundColor(.secondary)
                }
                
                // Animated Card
                AnimatedCard(animation: .spring, delay: 0.2) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Animated Card")
                            .font(.headline)
                        Text("This card animates in with a spring effect.")
                            .foregroundColor(.secondary)
                    }
                }
                
                // Glass Card (iOS 26+)
                Card(style: .glass) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Glass Card")
                            .font(.headline)
                        Text("A beautiful glassmorphism effect.")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Basic Form Example

struct FormExampleView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var acceptTerms = false
    @State private var selectedCountry = "United States"
    
    let countries = ["United States", "United Kingdom", "Canada", "Germany", "France"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Text Fields
                EnhancedTextField(
                    placeholder: "Full Name",
                    text: $name,
                    validation: .minLength(2)
                )
                
                EnhancedTextField(
                    placeholder: "Email",
                    text: $email,
                    validation: .email,
                    keyboardType: .emailAddress
                )
                
                EnhancedTextField(
                    placeholder: "Password",
                    text: $password,
                    validation: .minLength(8),
                    isSecure: true
                )
                
                // Picker
                EnhancedPicker(
                    selection: $selectedCountry,
                    options: countries,
                    label: "Country"
                )
                
                // Toggle
                StyledToggle(
                    isOn: $acceptTerms,
                    label: "I accept the terms and conditions"
                )
                
                // Submit Button
                PrimaryButton(title: "Create Account") {
                    createAccount()
                }
                .disabled(!isFormValid)
            }
            .padding()
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty && acceptTerms
    }
    
    private func createAccount() {
        // Handle account creation
    }
}

// MARK: - Basic List Example

struct ListExampleView: View {
    struct Item: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let icon: String
    }
    
    let items: [Item] = [
        Item(title: "Profile", subtitle: "View and edit your profile", icon: "person.circle"),
        Item(title: "Settings", subtitle: "App preferences", icon: "gear"),
        Item(title: "Notifications", subtitle: "Manage notifications", icon: "bell"),
        Item(title: "Privacy", subtitle: "Privacy settings", icon: "lock.shield"),
        Item(title: "Help", subtitle: "Get help and support", icon: "questionmark.circle"),
    ]
    
    var body: some View {
        SwipeableList(
            items: items,
            trailingActions: [
                SwipeAction(icon: "trash", color: .red) { item in
                    deleteItem(item)
                },
                SwipeAction(icon: "star", color: .yellow) { item in
                    favoriteItem(item)
                }
            ]
        ) { item in
            HStack(spacing: 16) {
                Image(systemName: item.icon)
                    .font(.title2)
                    .foregroundColor(.accentColor)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
    }
    
    private func deleteItem(_ item: Item) {
        // Delete item
    }
    
    private func favoriteItem(_ item: Item) {
        // Favorite item
    }
}

// MARK: - Basic Navigation Example

struct NavigationExampleView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        CustomTabBar(
            selectedIndex: $selectedTab,
            tabs: [
                TabItem(icon: Image(systemName: "house"), title: "Home", badge: nil),
                TabItem(icon: Image(systemName: "magnifyingglass"), title: "Search", badge: nil),
                TabItem(icon: Image(systemName: "bell"), title: "Notifications", badge: 5),
                TabItem(icon: Image(systemName: "person"), title: "Profile", badge: nil),
            ]
        ) {
            switch selectedTab {
            case 0:
                HomeView()
            case 1:
                SearchView()
            case 2:
                NotificationsView()
            case 3:
                ProfileView()
            default:
                EmptyView()
            }
        }
    }
}

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(0..<10) { index in
                        Card {
                            Text("Item \(index + 1)")
                                .font(.headline)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }
}

struct SearchView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText, placeholder: "Search...")
                Spacer()
            }
            .padding()
            .navigationTitle("Search")
        }
    }
}

struct NotificationsView: View {
    var body: some View {
        NavigationStack {
            Text("Notifications")
                .navigationTitle("Notifications")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            Text("Profile")
                .navigationTitle("Profile")
        }
    }
}

// MARK: - Basic Feedback Example

struct FeedbackExampleView: View {
    @State private var showToast = false
    @State private var showAlert = false
    @State private var progress: Double = 0.65
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 32) {
            // Progress
            VStack(alignment: .leading, spacing: 8) {
                Text("Progress")
                    .font(.headline)
                ProgressView(progress: progress, style: .linear, showPercentage: true)
                ProgressView(progress: progress, style: .circular, showPercentage: false)
                    .frame(width: 60, height: 60)
            }
            
            // Spinner
            VStack(alignment: .leading, spacing: 8) {
                Text("Loading States")
                    .font(.headline)
                HStack(spacing: 24) {
                    Spinner(style: .default)
                    Spinner(style: .dots)
                    Spinner(style: .pulse)
                }
            }
            
            // Toast Button
            PrimaryButton(title: "Show Toast") {
                showToast = true
            }
            
            // Alert Button
            SecondaryButton(title: "Show Alert") {
                showAlert = true
            }
        }
        .padding()
        .toast(
            isPresented: $showToast,
            message: "Operation completed successfully!",
            type: .success
        )
        .alert(isPresented: $showAlert) {
            StyledAlert(
                title: "Confirm Action",
                message: "Are you sure you want to proceed?",
                primaryButton: AlertButton(title: "Confirm", style: .destructive) {
                    // Confirm action
                },
                secondaryButton: AlertButton(title: "Cancel", style: .cancel)
            )
        }
    }
}

// MARK: - Preview Provider

#Preview("Buttons") {
    ButtonExampleView()
}

#Preview("Cards") {
    CardExampleView()
}

#Preview("Forms") {
    FormExampleView()
}

#Preview("Lists") {
    ListExampleView()
}

#Preview("Navigation") {
    NavigationExampleView()
}

#Preview("Feedback") {
    FeedbackExampleView()
}
