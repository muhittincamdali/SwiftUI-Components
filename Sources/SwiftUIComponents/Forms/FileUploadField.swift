import SwiftUI
import UniformTypeIdentifiers

/// A field that lets the user pick files, or drop them on the drop zone, and lists them.
///
/// Picked files are added to `selectedFiles` with `progress` 0 and `isUploaded` `false`. Upload
/// each file's ``UploadedFile/url`` yourself and update its `progress` and `isUploaded` through
/// the binding. Files over the limits are not added; `onRejected` reports them.
///
/// ```swift
/// FileUploadField(selectedFiles: $files, maxFiles: 3, allowedTypes: ["pdf", "png"]) { name, reason in
///     print("\(name) was not added: \(reason)")
/// }
/// ```
public struct FileUploadField: View {
    @Binding var selectedFiles: [UploadedFile]
    let maxFiles: Int
    let allowedTypes: [String]
    let maxFileSize: Int // in MB
    let style: UploadStyle
    let onRejected: ((String, Rejection) -> Void)?

    @State private var isDragging = false
    @State private var isImporting = false

    public struct UploadedFile: Identifiable {
        public let id = UUID()
        /// The file name, such as `"report.pdf"`.
        public let name: String
        /// The size in bytes.
        public let size: Int
        /// The lowercased file extension, such as `"pdf"`.
        public let type: String
        /// Where the picked or dropped file is; `nil` for files you create yourself. A file from
        /// the picker can be outside your app's sandbox: call
        /// `startAccessingSecurityScopedResource()` on the URL before you read it.
        public let url: URL?
        /// The upload progress from 0 to 1, shown while `isUploaded` is `false`.
        public var progress: Double
        public var isUploaded: Bool

        public init(
            name: String,
            size: Int,
            type: String,
            url: URL? = nil,
            progress: Double = 0,
            isUploaded: Bool = false
        ) {
            self.name = name
            self.size = size
            self.type = type
            self.url = url
            self.progress = progress
            self.isUploaded = isUploaded
        }
    }

    /// Why a picked or dropped file was not added.
    public enum Rejection: Equatable, Sendable {
        /// `maxFiles` files are already selected.
        case tooManyFiles
        /// The file's extension is not in `allowedTypes`.
        case unsupportedType
        /// The file is larger than `maxFileSize` megabytes.
        case tooLarge
        /// The file's size could not be read.
        case unreadable
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
        style: UploadStyle = .dropzone,
        onRejected: ((String, Rejection) -> Void)? = nil
    ) {
        self._selectedFiles = selectedFiles
        self.maxFiles = maxFiles
        self.allowedTypes = allowedTypes
        self.maxFileSize = maxFileSize
        self.style = style
        self.onRejected = onRejected
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
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: Self.contentTypes(for: allowedTypes),
            allowsMultipleSelection: true
        ) { result in
            if case .success(let urls) = result { add(urls) }
        }
    }

    private var isFull: Bool { selectedFiles.count >= maxFiles }

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
                    isImporting = true
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.accentColor)
                .disabled(isFull)
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
                .foregroundColor(isDragging ? .accentColor : Color.platformGray4)
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isDragging ? Color.accentColor.opacity(0.05) : Color.platformGray6.opacity(0.5))
        )
        .dropDestination(for: URL.self) { urls, _ in
            add(urls)
            return !urls.isEmpty
        } isTargeted: { isTargeted in
            isDragging = isTargeted
        }
    }

    private var buttonView: some View {
        Button {
            isImporting = true
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
                    .stroke(Color.platformGray4, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isFull)
    }

    private var compactView: some View {
        HStack {
            Button {
                isImporting = true
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
            .disabled(isFull)

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
                                .fill(Color.platformGray5)
                                .frame(height: 4)

                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.accentColor)
                                .frame(width: geometry.size.width * Self.clampedProgress(file.progress), height: 4)
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
        .background(Color.platformBackground)
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

    /// Adds the files that pass the limits and reports the others to `onRejected`.
    private func add(_ urls: [URL]) {
        var count = selectedFiles.count
        for url in urls {
            let isScoped = url.startAccessingSecurityScopedResource()
            let size = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize
            if isScoped { url.stopAccessingSecurityScopedResource() }

            let name = url.lastPathComponent
            if let reason = Self.rejection(
                name: name,
                size: size,
                currentCount: count,
                maxFiles: maxFiles,
                allowedTypes: allowedTypes,
                maxFileSize: maxFileSize
            ) {
                onRejected?(name, reason)
                continue
            }
            selectedFiles.append(UploadedFile(
                name: name,
                size: size ?? 0,
                type: url.pathExtension.lowercased(),
                url: url
            ))
            count += 1
        }
    }
}

// MARK: - Rules

extension FileUploadField {
    /// The bytes in one of the megabytes `maxFileSize` counts, matching the sizes the rows show.
    nonisolated static let bytesPerMegabyte = 1_048_576.0

    /// Why a file called `name` of `size` bytes cannot join `currentCount` selected files, or
    /// `nil` when it can. Extensions compare without case and without a leading dot; an empty
    /// `allowedTypes` allows every type.
    nonisolated static func rejection(
        name: String,
        size: Int?,
        currentCount: Int,
        maxFiles: Int,
        allowedTypes: [String],
        maxFileSize: Int
    ) -> Rejection? {
        guard currentCount < maxFiles else { return .tooManyFiles }
        let fileExtension = URL(fileURLWithPath: name).pathExtension.lowercased()
        let allowed = allowedTypes.map(normalizedExtension)
        if !allowed.isEmpty, !allowed.contains(fileExtension) { return .unsupportedType }
        guard let size, size >= 0 else { return .unreadable }
        // In `Double`, so a large `maxFileSize` cannot overflow the multiplication.
        guard Double(size) <= Double(max(maxFileSize, 0)) * bytesPerMegabyte else { return .tooLarge }
        return nil
    }

    /// The types the file picker offers. Unknown extensions are skipped; when none is known the
    /// picker offers every file and ``rejection(name:size:currentCount:maxFiles:allowedTypes:maxFileSize:)``
    /// still checks the extension.
    nonisolated static func contentTypes(for allowedTypes: [String]) -> [UTType] {
        let types = allowedTypes.compactMap { UTType(filenameExtension: normalizedExtension($0)) }
        return types.isEmpty ? [.item] : types
    }

    nonisolated static func normalizedExtension(_ type: String) -> String {
        let trimmed = type.trimmingCharacters(in: .whitespaces).lowercased()
        return trimmed.hasPrefix(".") ? String(trimmed.dropFirst()) : trimmed
    }

    /// `progress` within 0...1; NaN becomes 0.
    nonisolated static func clampedProgress(_ progress: Double) -> Double {
        progress.isNaN ? 0 : min(max(progress, 0), 1)
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
