import UIKit
import WebKit

/// Reads the colors the website actually draws at its top and bottom edges, the way Safari tints its bars.
/// Used to keep the status bar readable and to fill the area behind the home indicator.
@MainActor
enum EdgeColorSampler {

    /// Average color the page draws inside `rect` (web view coordinates), or nil if it can't be measured yet.
    static func averageColor(of webView: WKWebView, in rect: CGRect) async -> UIColor? {
        guard rect.width > 0, rect.height > 0 else { return nil }
        let configuration = WKSnapshotConfiguration()
        configuration.rect = rect
        configuration.snapshotWidth = 64
        configuration.afterScreenUpdates = false
        guard let image = try? await webView.takeSnapshot(configuration: configuration),
              let cgImage = image.cgImage else { return nil }

        var pixel = [UInt8](repeating: 0, count: 4)
        pixel.withUnsafeMutableBytes { buffer in
            guard let context = CGContext(
                data: buffer.baseAddress, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4,
                space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) else { return }
            context.interpolationQuality = .medium
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        return UIColor(red: CGFloat(pixel[0]) / 255, green: CGFloat(pixel[1]) / 255, blue: CGFloat(pixel[2]) / 255, alpha: 1)
    }

    static func isDark(_ color: UIColor) -> Bool {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return 0.2126 * red + 0.7152 * green + 0.0722 * blue < 0.5
    }
}
