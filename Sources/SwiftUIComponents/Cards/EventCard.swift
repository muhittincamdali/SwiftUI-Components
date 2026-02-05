import SwiftUI

/// A card for displaying events and schedules
public struct EventCard: View {
    let title: String
    let description: String?
    let date: Date
    let endDate: Date?
    let location: String?
    let attendees: Int?
    let category: String?
    let color: Color
    let style: EventCardStyle
    let onTap: (() -> Void)?
    
    public enum EventCardStyle {
        case standard
        case compact
        case timeline
        case calendar
    }
    
    public init(
        title: String,
        description: String? = nil,
        date: Date,
        endDate: Date? = nil,
        location: String? = nil,
        attendees: Int? = nil,
        category: String? = nil,
        color: Color = .accentColor,
        style: EventCardStyle = .standard,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.date = date
        self.endDate = endDate
        self.location = location
        self.attendees = attendees
        self.category = category
        self.color = color
        self.style = style
        self.onTap = onTap
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }
    
    private var weekdayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }
    
    public var body: some View {
        Group {
            switch style {
            case .standard:
                standardView
            case .compact:
                compactView
            case .timeline:
                timelineView
            case .calendar:
                calendarView
            }
        }
        .onTapGesture { onTap?() }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) on \(dateFormatter.string(from: date))")
    }
    
    private var standardView: some View {
        HStack(spacing: 12) {
            // Color indicator
            Rectangle()
                .fill(color)
                .frame(width: 4)
                .cornerRadius(2)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if let category = category {
                        Text(category.uppercased())
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(color)
                    }
                    Spacer()
                    Text(dateFormatter.string(from: date))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                
                if let description = description {
                    Text(description)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                        Text(timeFormatter.string(from: date))
                            .font(.system(size: 12))
                        if let endDate = endDate {
                            Text("- \(timeFormatter.string(from: endDate))")
                                .font(.system(size: 12))
                        }
                    }
                    .foregroundColor(.secondary)
                    
                    if let location = location {
                        HStack(spacing: 4) {
                            Image(systemName: "location")
                                .font(.system(size: 12))
                            Text(location)
                                .font(.system(size: 12))
                                .lineLimit(1)
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if let attendees = attendees {
                        HStack(spacing: 4) {
                            Image(systemName: "person.2")
                                .font(.system(size: 12))
                            Text("\(attendees)")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
    
    private var compactView: some View {
        HStack(spacing: 12) {
            // Date box
            VStack(spacing: 2) {
                Text(monthFormatter.string(from: date).uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(color)
                Text(dayFormatter.string(from: date))
                    .font(.system(size: 20, weight: .bold))
            }
            .frame(width: 50, height: 50)
            .background(color.opacity(0.15))
            .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)
                
                Text(timeFormatter.string(from: date))
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
    
    private var timelineView: some View {
        HStack(alignment: .top, spacing: 16) {
            // Timeline
            VStack(spacing: 4) {
                Circle()
                    .fill(color)
                    .frame(width: 12, height: 12)
                
                Rectangle()
                    .fill(color.opacity(0.3))
                    .frame(width: 2)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(timeFormatter.string(from: date))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                
                if let description = description {
                    Text(description)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                
                if let location = location {
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .font(.system(size: 11))
                        Text(location)
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    private var calendarView: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(weekdayFormatter.string(from: date).uppercased())
                    .font(.system(size: 11, weight: .bold))
                Text(dayFormatter.string(from: date))
                    .font(.system(size: 11, weight: .bold))
                Spacer()
                Text(timeFormatter.string(from: date))
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(color)
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                
                if let location = location {
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .font(.system(size: 11))
                        Text(location)
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.secondary)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
    }
}

#Preview("Event Cards") {
    ScrollView {
        VStack(spacing: 16) {
            EventCard(
                title: "Team Meeting",
                description: "Weekly sync to discuss project progress and blockers.",
                date: Date(),
                endDate: Date().addingTimeInterval(3600),
                location: "Conference Room A",
                attendees: 8,
                category: "Work",
                color: .blue,
                style: .standard
            )
            
            EventCard(
                title: "Dentist Appointment",
                date: Date().addingTimeInterval(86400),
                location: "Downtown Clinic",
                color: .red,
                style: .compact
            )
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Today's Schedule")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.bottom, 16)
                
                EventCard(
                    title: "Morning Standup",
                    description: "Quick sync with the team",
                    date: Date(),
                    location: "Zoom",
                    color: .green,
                    style: .timeline
                )
                
                EventCard(
                    title: "Lunch with Client",
                    date: Date().addingTimeInterval(7200),
                    location: "Cafe Milano",
                    color: .orange,
                    style: .timeline
                )
                
                EventCard(
                    title: "Code Review",
                    date: Date().addingTimeInterval(14400),
                    color: .purple,
                    style: .timeline
                )
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            
            HStack(spacing: 12) {
                EventCard(
                    title: "Yoga Class",
                    date: Date(),
                    location: "Gym",
                    color: .mint,
                    style: .calendar
                )
                
                EventCard(
                    title: "Team Dinner",
                    date: Date().addingTimeInterval(86400 * 2),
                    location: "Restaurant",
                    color: .pink,
                    style: .calendar
                )
            }
        }
        .padding()
    }
    .background(Color(.systemGray6))
}
