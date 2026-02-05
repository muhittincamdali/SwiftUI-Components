import SwiftUI
import Combine

/// A countdown timer view
public struct CountdownTimer: View {
    let targetDate: Date
    let style: TimerStyle
    let onComplete: (() -> Void)?
    
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State private var cancellable: Cancellable?
    
    public enum TimerStyle {
        case standard
        case compact
        case large
        case cards
    }
    
    public init(
        targetDate: Date,
        style: TimerStyle = .standard,
        onComplete: (() -> Void)? = nil
    ) {
        self.targetDate = targetDate
        self.style = style
        self.onComplete = onComplete
    }
    
    private var components: (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let total = max(0, Int(timeRemaining))
        let days = total / 86400
        let hours = (total % 86400) / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60
        return (days, hours, minutes, seconds)
    }
    
    public var body: some View {
        Group {
            switch style {
            case .standard:
                standardView
            case .compact:
                compactView
            case .large:
                largeView
            case .cards:
                cardsView
            }
        }
        .onAppear {
            updateTimeRemaining()
            cancellable = timer.autoconnect().sink { _ in
                updateTimeRemaining()
            }
        }
        .onDisappear {
            cancellable?.cancel()
        }
    }
    
    private func updateTimeRemaining() {
        timeRemaining = targetDate.timeIntervalSinceNow
        if timeRemaining <= 0 {
            cancellable?.cancel()
            onComplete?()
        }
    }
    
    private var standardView: some View {
        HStack(spacing: 20) {
            if components.days > 0 {
                timeUnit(value: components.days, label: "Days")
            }
            timeUnit(value: components.hours, label: "Hours")
            timeUnit(value: components.minutes, label: "Min")
            timeUnit(value: components.seconds, label: "Sec")
        }
    }
    
    private var compactView: some View {
        Text(String(format: "%02d:%02d:%02d", components.hours, components.minutes, components.seconds))
            .font(.system(size: 24, weight: .bold, design: .monospaced))
    }
    
    private var largeView: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                if components.days > 0 {
                    Text(String(format: "%02d", components.days))
                    Text(":")
                }
                Text(String(format: "%02d", components.hours))
                Text(":")
                Text(String(format: "%02d", components.minutes))
                Text(":")
                Text(String(format: "%02d", components.seconds))
            }
            .font(.system(size: 48, weight: .bold, design: .monospaced))
            
            HStack(spacing: 28) {
                if components.days > 0 {
                    Text("Days")
                }
                Text("Hours")
                Text("Min")
                Text("Sec")
            }
            .font(.system(size: 12))
            .foregroundColor(.secondary)
        }
    }
    
    private var cardsView: some View {
        HStack(spacing: 8) {
            if components.days > 0 {
                timeCard(value: components.days, label: "Days")
            }
            timeCard(value: components.hours, label: "Hours")
            timeCard(value: components.minutes, label: "Min")
            timeCard(value: components.seconds, label: "Sec")
        }
    }
    
    private func timeUnit(value: Int, label: String) -> some View {
        VStack(spacing: 4) {
            Text(String(format: "%02d", value))
                .font(.system(size: 28, weight: .bold, design: .monospaced))
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
    }
    
    private func timeCard(value: Int, label: String) -> some View {
        VStack(spacing: 4) {
            Text(String(format: "%02d", value))
                .font(.system(size: 24, weight: .bold, design: .monospaced))
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 60)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

/// A stopwatch view
public struct Stopwatch: View {
    @State private var elapsedTime: TimeInterval = 0
    @State private var isRunning = false
    @State private var laps: [TimeInterval] = []
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 0.01, on: .main, in: .common)
    @State private var cancellable: Cancellable?
    
    let showLaps: Bool
    let style: StopwatchStyle
    
    public enum StopwatchStyle {
        case standard
        case compact
        case analog
    }
    
    public init(showLaps: Bool = true, style: StopwatchStyle = .standard) {
        self.showLaps = showLaps
        self.style = style
    }
    
    private var formattedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        let centiseconds = Int((elapsedTime.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, centiseconds)
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            // Time display
            Text(formattedTime)
                .font(.system(size: style == .compact ? 32 : 56, weight: .thin, design: .monospaced))
            
            // Controls
            HStack(spacing: 40) {
                // Reset/Lap button
                Button {
                    if isRunning {
                        laps.append(elapsedTime)
                    } else {
                        elapsedTime = 0
                        laps.removeAll()
                    }
                } label: {
                    Text(isRunning ? "Lap" : "Reset")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 80, height: 80)
                        .background(Color(.systemGray5))
                        .clipShape(Circle())
                }
                .disabled(!isRunning && elapsedTime == 0)
                
                // Start/Stop button
                Button {
                    isRunning.toggle()
                    if isRunning {
                        timer = Timer.publish(every: 0.01, on: .main, in: .common)
                        cancellable = timer.autoconnect().sink { _ in
                            elapsedTime += 0.01
                        }
                    } else {
                        cancellable?.cancel()
                    }
                } label: {
                    Text(isRunning ? "Stop" : "Start")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background(isRunning ? Color.red : Color.green)
                        .clipShape(Circle())
                }
            }
            
            // Laps
            if showLaps && !laps.isEmpty {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(laps.indices.reversed(), id: \.self) { index in
                            HStack {
                                Text("Lap \(index + 1)")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(formatTime(laps[index]))
                                    .font(.system(size: 16, design: .monospaced))
                            }
                            .padding(.vertical, 10)
                            
                            if index > 0 {
                                Divider()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 200)
            }
        }
        .onDisappear {
            cancellable?.cancel()
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let centiseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, centiseconds)
    }
}

/// A progress timer with visual feedback
public struct ProgressTimer: View {
    let duration: TimeInterval
    let onComplete: (() -> Void)?
    
    @State private var progress: Double = 0
    @State private var isRunning = false
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 0.1, on: .main, in: .common)
    @State private var cancellable: Cancellable?
    
    public init(duration: TimeInterval, onComplete: (() -> Void)? = nil) {
        self.duration = duration
        self.onComplete = onComplete
    }
    
    private var remainingTime: TimeInterval {
        duration * (1 - progress)
    }
    
    private var formattedRemaining: String {
        let total = Int(remainingTime)
        let minutes = total / 60
        let seconds = total % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            // Circular progress
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 12)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.1), value: progress)
                
                VStack(spacing: 4) {
                    Text(formattedRemaining)
                        .font(.system(size: 36, weight: .medium, design: .monospaced))
                    
                    Text(isRunning ? "Running" : "Paused")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 200, height: 200)
            
            // Controls
            HStack(spacing: 20) {
                Button {
                    progress = 0
                    isRunning = false
                    cancellable?.cancel()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 24))
                        .foregroundColor(.primary)
                        .frame(width: 50, height: 50)
                        .background(Color(.systemGray5))
                        .clipShape(Circle())
                }
                
                Button {
                    isRunning.toggle()
                    if isRunning {
                        timer = Timer.publish(every: 0.1, on: .main, in: .common)
                        cancellable = timer.autoconnect().sink { _ in
                            if progress < 1 {
                                progress += 0.1 / duration
                            } else {
                                isRunning = false
                                cancellable?.cancel()
                                onComplete?()
                            }
                        }
                    } else {
                        cancellable?.cancel()
                    }
                } label: {
                    Image(systemName: isRunning ? "pause.fill" : "play.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                        .frame(width: 70, height: 70)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                }
            }
        }
        .onDisappear {
            cancellable?.cancel()
        }
    }
}

#Preview("Timer Components") {
    ScrollView {
        VStack(spacing: 40) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Countdown Timer")
                    .font(.headline)
                
                CountdownTimer(
                    targetDate: Date().addingTimeInterval(3600 * 24 + 3661),
                    style: .cards
                )
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Stopwatch")
                    .font(.headline)
                
                Stopwatch()
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Progress Timer")
                    .font(.headline)
                
                ProgressTimer(duration: 60)
            }
        }
        .padding()
    }
}
