import SwiftUI

/// A styled date picker field
public struct DateField: View {
    @Binding var date: Date
    let label: String?
    let style: DateFieldStyle
    let displayComponents: DatePicker<Text>.Components
    
    @State private var isExpanded = false
    
    public enum DateFieldStyle {
        case inline
        case compact
        case wheel
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = displayComponents.contains(.date) ? .medium : .none
        formatter.timeStyle = displayComponents.contains(.hourAndMinute) ? .short : .none
        return formatter
    }
    
    public init(
        date: Binding<Date>,
        label: String? = nil,
        style: DateFieldStyle = .compact,
        displayComponents: DatePicker<Text>.Components = .date
    ) {
        self._date = date
        self.label = label
        self.style = style
        self.displayComponents = displayComponents
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let label = label {
                Text(label)
                    .font(.system(size: 14, weight: .medium))
            }
            
            switch style {
            case .inline:
                DatePicker("", selection: $date, displayedComponents: displayComponents)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                
            case .compact:
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack {
                        Image(systemName: displayComponents.contains(.hourAndMinute) ? "clock" : "calendar")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                        
                        Text(dateFormatter.string(from: date))
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isExpanded ? Color.accentColor : Color(.systemGray4), lineWidth: isExpanded ? 2 : 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                if isExpanded {
                    DatePicker("", selection: $date, displayedComponents: displayComponents)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
            case .wheel:
                DatePicker("", selection: $date, displayedComponents: displayComponents)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
            }
        }
    }
}

/// A time slot picker
public struct TimeSlotPicker: View {
    @Binding var selectedSlot: String?
    let slots: [String]
    let columns: Int
    
    public init(
        selectedSlot: Binding<String?>,
        slots: [String],
        columns: Int = 4
    ) {
        self._selectedSlot = selectedSlot
        self.slots = slots
        self.columns = columns
    }
    
    public var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: columns), spacing: 8) {
            ForEach(slots, id: \.self) { slot in
                Button {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                        selectedSlot = slot
                    }
                } label: {
                    Text(slot)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedSlot == slot ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedSlot == slot ? Color.accentColor : Color(.systemGray6))
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

/// Duration picker
public struct DurationPicker: View {
    @Binding var duration: TimeInterval
    let presets: [TimeInterval]?
    let showCustom: Bool
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var showCustomPicker = false
    
    public init(
        duration: Binding<TimeInterval>,
        presets: [TimeInterval]? = [900, 1800, 3600, 5400, 7200],
        showCustom: Bool = true
    ) {
        self._duration = duration
        self.presets = presets
        self.showCustom = showCustom
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            if let presets = presets {
                FlowLayout(spacing: 8) {
                    ForEach(presets, id: \.self) { preset in
                        Button {
                            withAnimation {
                                duration = preset
                                showCustomPicker = false
                            }
                        } label: {
                            Text(formatDuration(preset))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(duration == preset && !showCustomPicker ? .white : .primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(duration == preset && !showCustomPicker ? Color.accentColor : Color(.systemGray6))
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    if showCustom {
                        Button {
                            withAnimation {
                                showCustomPicker.toggle()
                            }
                        } label: {
                            Text("Custom")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(showCustomPicker ? .white : .primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(showCustomPicker ? Color.accentColor : Color(.systemGray6))
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            if showCustomPicker {
                HStack(spacing: 16) {
                    VStack(spacing: 4) {
                        Picker("Hours", selection: $hours) {
                            ForEach(0..<24, id: \.self) { h in
                                Text("\(h)").tag(h)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 80, height: 120)
                        .clipped()
                        
                        Text("Hours")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(spacing: 4) {
                        Picker("Minutes", selection: $minutes) {
                            ForEach([0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55], id: \.self) { m in
                                Text("\(m)").tag(m)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 80, height: 120)
                        .clipped()
                        
                        Text("Minutes")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                .onChange(of: hours) { _, _ in updateDuration() }
                .onChange(of: minutes) { _, _ in updateDuration() }
            }
        }
    }
    
    private func updateDuration() {
        duration = TimeInterval(hours * 3600 + minutes * 60)
    }
    
    private func formatDuration(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = Int(interval) % 3600 / 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours) hour\(hours > 1 ? "s" : "")"
        } else {
            return "\(minutes) min"
        }
    }
}

#Preview("Date & Time Fields") {
    struct PreviewWrapper: View {
        @State private var date = Date()
        @State private var selectedSlot: String? = "10:00"
        @State private var duration: TimeInterval = 1800
        
        var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    DateField(
                        date: $date,
                        label: "Appointment Date",
                        style: .compact
                    )
                    
                    DateField(
                        date: $date,
                        label: "Select Time",
                        style: .compact,
                        displayComponents: .hourAndMinute
                    )
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Available Slots")
                            .font(.system(size: 14, weight: .medium))
                        
                        TimeSlotPicker(
                            selectedSlot: $selectedSlot,
                            slots: ["9:00", "9:30", "10:00", "10:30", "11:00", "11:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30"]
                        )
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Duration")
                            .font(.system(size: 14, weight: .medium))
                        
                        DurationPicker(duration: $duration)
                    }
                }
                .padding()
            }
        }
    }
    return PreviewWrapper()
}
