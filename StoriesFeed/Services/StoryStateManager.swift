import Foundation

@MainActor
@Observable
final class StoryStateManager {
    static let shared = StoryStateManager()
    private let likedKey = "likedStoryIds"
    private let seenAtKey = "seenAt"

    private(set) var likedStoryIds: Set<String>
    private(set) var seenAt: [String: Double]

    private init() {
        let arr = UserDefaults.standard.stringArray(forKey: "likedStoryIds") ?? []
        likedStoryIds = Set(arr)
        seenAt = UserDefaults.standard.dictionary(forKey: "seenAt") as? [String: Double] ?? [:]
    }

    func toggleLike(_ story: Story) {
        if likedStoryIds.contains(story.sourceId) {
            likedStoryIds.remove(story.sourceId)
        } else {
            likedStoryIds.insert(story.sourceId)
        }
        persist()
    }

    func isLiked(_ story: Story) -> Bool {
        likedStoryIds.contains(story.sourceId)
    }

    func markSeen(_ story: Story) {
        guard seenAt[story.sourceId] == nil else { return }
        seenAt[story.sourceId] = Date.now.timeIntervalSince1970
        persist()
    }

    func isSeen(_ story: Story) -> Bool {
        seenAt[story.sourceId] != nil
    }

    func seenDate(for story: Story) -> Date? {
        guard let t = seenAt[story.sourceId] else { return nil }
        return Date(timeIntervalSince1970: t)
    }

    func isUserFullySeen(_ user: StoryUser) -> Bool {
        user.stories.allSatisfy(isSeen)
    }

    private func persist() {
        UserDefaults.standard.set(Array(likedStoryIds), forKey: likedKey)
        UserDefaults.standard.set(seenAt, forKey: seenAtKey)
    }
}
