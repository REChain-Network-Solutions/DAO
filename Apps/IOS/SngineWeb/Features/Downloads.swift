import UIKit
import WebKit

/// Saves files the website offers for download, then opens the share sheet ("Save to Files", "Save Image"…).
/// Works for normal links as well as `blob:` and `data:` URLs.
@MainActor
final class Downloads: NSObject, WKDownloadDelegate {
    private weak var presenter: WebHost?
    private weak var sourceView: UIView?
    private var destinations: [ObjectIdentifier: URL] = [:]

    init(presenter: WebHost, sourceView: UIView) {
        self.presenter = presenter
        self.sourceView = sourceView
    }

    func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String) async -> URL? {
        let folder = FileManager.default.temporaryDirectory.appendingPathComponent("Downloads", isDirectory: true)
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        } catch {
            return nil
        }
        let name = suggestedFilename.isEmpty ? "download" : suggestedFilename
        let destination = folder.appendingPathComponent(name)
        destinations[ObjectIdentifier(download)] = destination
        return destination
    }

    func downloadDidFinish(_ download: WKDownload) {
        guard let file = destinations.removeValue(forKey: ObjectIdentifier(download)) else { return }
        let share = UIActivityViewController(activityItems: [file], applicationActivities: nil)
        share.popoverPresentationController?.sourceView = sourceView
        share.popoverPresentationController?.sourceRect = sourceView.map { CGRect(x: $0.bounds.midX, y: $0.bounds.midY, width: 0, height: 0) } ?? .zero
        presenter?.present(share)
    }

    func download(_ download: WKDownload, didFailWithError error: Error, resumeData: Data?) {
        destinations.removeValue(forKey: ObjectIdentifier(download))
        let alert = UIAlertController(
            title: String(localized: "Download failed"),
            message: String(localized: "This file can't be downloaded."),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: String(localized: "OK"), style: .default))
        presenter?.present(alert)
    }
}
