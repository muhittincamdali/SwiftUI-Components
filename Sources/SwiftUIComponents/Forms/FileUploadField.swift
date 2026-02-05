import SwiftUI

/// A file upload field with drag and drop support
public struct FileUploadField: View {
    @Binding var selectedFiles: [UploadedFile]
    let maxFiles: Int
    let allowedTypes: [String]
    let maxFileSize: Int // in MB
    let style: UploadStyle
    
    @State private var isDragging = false
    
    public struct UploadedFile: Identifiable {
        public let id = UUID()
        let name: String
        let size: Int
        let type: String
        var progress: Double
        var isUploaded: Bool
        
        public init(name: String, size: Int, type: String, progress: Double = 0, isUploaded: Bool = false) {
            self.name = name
            self.size = size
            self.type = type
            self.progress = progress
            self.isUploaded = isUploaded
        }
    }
    
    public enum UploadStyle {
        case dropzone
        case button
        case compact
    }
    
    public init(
        selectedFiles: Binding<[UploadedFile]>,
        maxFiles: Int = 5,
        allowedTypes: [String] = ["pdf", "doc", "docx", "jpg", "png"],
        maxFileSize: Int = 10,
        style: UploadStyle = .dropzone
    ) {
        self._selectedFiles = selectedFiles
        self.maxFiles = maxFiles
        self.allowedTypes = allowedTypes
        self.maxFileSize = maxFileSize
        self.style = style
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            switch style {
            case .dropzone:
                dropzoneView
            case .button:
                buttonView
            case .compact:
                compactView
            }
            
            // File list
            if !selectedFiles.isEmpty {
                VStack(spacing: 8) {
                    ForEach(selectedFiles) { file in
                        fileRow(file)
                    }
                }
            }
        }
    }
    
    private var dropzoneView: some View {
        VStack(spacing: 12) {
            Image(systemName: "icloud.and.arrow.up")
                .font(.system(size: 32))
                .foregroundColor(isDragging ? .accentColor : .secondary)
            
            VStack(spacing: 4) {
                Text("Drag and drop files here")
                    .font(.system(size: 15, weight: .medium))
                
                Text("or")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                
                Button("Browse Files") {
                    // File picker action
                    addDemoFile()
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.accentColor)
            }
            
            Text("Max \(maxFiles) files • \(allowedTypes.joined(separator: ", ").uppercased()) • Up to \(maxFileSize)MB each")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                .foregroundColor(isDragging ? .accentColor : Color(.systemGray4))
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isDragging ? Color.accentColor.opacity(0.05) : Color(.systemGray6).opacity(0.5))
        )
    }
    
    private var buttonView: some View {
        Button {
            addDemoFile()
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Upload Files")
                        .font(.system(size: 15, weight: .semibold))
                    
                    Text("\(selectedFiles.count)/\(maxFiles) files")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .foregroundColor(.primary)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(selectedFiles.count >= maxFiles)
    }
    
    private var compactView: some View {
        HStack {
            Button {
                addDemoFile()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "paperclip")
                        .font(.system(size: 16))
                    Text("Attach files")
                        .font(.system(size: 14))
                }
                .foregroundColor(.accentColor)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(selectedFiles.count >= maxFiles)
            
            Spacer()
            
            Text("\(selectedFiles.count)/\(maxFiles)")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
    }
    
    private func fileRow(_ file: UploadedFile) -> some View {
        HStack(spacing: 12) {
            // File icon
            Image(systemName: fileIcon(for: file.type))
                .font(.system(size: 20))
                .foregroundColor(fileColor(for: file.type))
                .frame(width: 40, height: 40)
                .background(fileColor(for: file.type).opacity(0.15))
                .cornerRadius(8)
            
            // File info
            VStack(alignment: .leading, spacing: 4) {
                Text(file.name)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)
                
                if file.isUploaded {
                    Text(formatFileSize(file.size))
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                } else {
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(.systemGray5))
                                .frame(height: 4)
                            
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.accentColor)
                                .frame(width: geometry.size.width * file.progress, height: 4)
                        }
                    }
                    .frame(height: 4)
                }
            }
            
            Spacer()
            
            // Status/Actions
            if file.isUploaded {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.green)
            }
            
            Button {
                selectedFiles.removeAll { $0.id == file.id }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(6)
            }
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    
    private func fileIcon(for type: String) -> String {
        switch type.lowercased() {
        case "pdf": return "doc.fill"
        case "doc", "docx": return "doc.text.fill"
        case "jpg", "jpeg", "png", "gif": return "photo.fill"
        case "mp4", "mov": return "video.fill"
        case "mp3", "wav": return "music.note"
        case "zip", "rar": return "archivebox.fill"
        default: return "doc.fill"
        }
    }
    
    private func fileColor(for type: String) -> Color {
        switch type.lowercased() {
        case "pdf": return .red
        case "doc", "docx": return .blue
        case "jpg", "jpeg", "png", "gif": return .green
        case "mp4", "mov": return .purple
        case "mp3", "wav": return .orange
        default: return .gray
        }
    }
    
    private func formatFileSize(_ bytes: Int) -> String {
        let kb = Double(bytes) / 1024
        if kb < 1024 {
            return String(format: "%.1f KB", kb)
        } else {
            return String(format: "%.1f MB", kb / 1024)
        }
    }
    
    private func addDemoFile() {
        guard selectedFiles.count < maxFiles else { return }
        let demo = UploadedFile(
            name: "document_\(selectedFiles.count + 1).pdf",
            size: Int.random(in: 100_000...5_000_000),
            type: "pdf",
            progress: 1.0,
            isUploaded: true
        )
        selectedFiles.append(demo)
    }
}

#Preview("File Upload") {
    struct PreviewWrapper: View {
        @State private var files1: [FileUploadField.UploadedFile] = []
        @State private var files2: [FileUploadField.UploadedFile] = [
            .init(name: "report.pdf", size: 2_500_000, type: "pdf", progress: 1.0, isUploaded: true),
            .init(name: "photo.jpg", size: 1_200_000, type: "jpg", progress: 0.6, isUploaded: false)
        ]
        
        var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    FormField(label: "Attachments") {
                        FileUploadField(selectedFiles: $files1, style: .dropzone)
                    }
                    
                    Divider()
                    
                    FormField(label: "Documents") {
                        FileUploadField(selectedFiles: $files2, style: .button)
                    }
                    
                    Divider()
                    
                    FormField(label: "Quick Upload") {
                        FileUploadField(selectedFiles: $files1, style: .compact)
                    }
                }
                .padding()
            }
        }
    }
    return PreviewWrapper()
}
