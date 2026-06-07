import SwiftUI

@MainActor
@Observable
final class ImageLoader {
    private(set) var image: UIImage?

    private static let cache: NSCache<NSString, UIImage> = {
        let c = NSCache<NSString, UIImage>()
        c.countLimit = 150
        c.totalCostLimit = 50 * 1024 * 1024  // 50 MB
        return c
    }()

    private static let session: URLSession = {
        let diskCache = URLCache(
            memoryCapacity: 25 * 1024 * 1024,   // 25 MB RAM
            diskCapacity: 150 * 1024 * 1024      // 150 MB disk
        )
        let config = URLSessionConfiguration.default
        config.urlCache = diskCache
        config.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: config)
    }()

    private var currentURL: URL?
    private var loadTask: Task<Void, Never>?

    func load(url: URL) {
        guard url != currentURL else { return }
        loadTask?.cancel()
        currentURL = url

        let key = url.absoluteString as NSString
        if let cached = Self.cache.object(forKey: key) {
            image = cached
            return
        }

        image = nil
        loadTask = Task {
            guard let (data, _) = try? await Self.session.data(from: url),
                  !Task.isCancelled else { return }
            let decoded = await decodeImage(data)
            guard !Task.isCancelled, let decoded else { return }
            let cost = Int(decoded.size.width * decoded.size.height * 4)
            Self.cache.setObject(decoded, forKey: key, cost: cost)
            self.image = decoded
        }
    }

    func cancel() {
        loadTask?.cancel()
        loadTask = nil
    }

    @concurrent
    nonisolated private func decodeImage(_ data: Data) async -> UIImage? {
        UIImage(data: data)?.preparingForDisplay()
    }
}
