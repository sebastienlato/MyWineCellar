import Foundation
import UIKit

enum PhotoStore {
    private static let directoryName = "wines"

    static func saveImage(_ image: UIImage, maxDimension: CGFloat = 2000, compression: CGFloat = 0.85) -> String? {
        let resized = image.resized(maxDimension: maxDimension) ?? image
        guard let data = resized.jpegData(compressionQuality: compression) else { return nil }
        return saveImageData(data)
    }

    // Writes already-encoded image bytes (JPEG recommended)
    static func saveImageData(_ data: Data) -> String? {
        do {
            let filename = "\(UUID().uuidString).jpg"
            let url = try fileURL(for: filename)
            try data.write(to: url, options: [.atomic])
            return filename
        } catch {
            return nil
        }
    }

    static func loadImage(filename: String) -> UIImage? {
        guard let url = try? fileURL(for: filename) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    static func removeImage(filename: String) {
        guard let url = try? fileURL(for: filename) else { return }
        try? FileManager.default.removeItem(at: url)
    }

    // MARK: - Paths

    private static func fileURL(for filename: String) throws -> URL {
        let directory = try directoryURL()
        return directory.appendingPathComponent(filename)
    }

    private static func directoryURL() throws -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let directory = (documents ?? URL(fileURLWithPath: NSTemporaryDirectory()))
            .appendingPathComponent(directoryName, isDirectory: true)

        if !FileManager.default.fileExists(atPath: directory.path) {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        }
        return directory
    }
}

private extension UIImage {
    func resized(maxDimension: CGFloat) -> UIImage? {
        let w = size.width
        let h = size.height
        let maxSide = max(w, h)
        guard maxSide > maxDimension else { return nil }

        let scale = maxDimension / maxSide
        let newSize = CGSize(width: w * scale, height: h * scale)

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1 // keep file size down
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

