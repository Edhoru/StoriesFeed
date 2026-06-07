import Foundation

@MainActor
@Observable
final class StoryStateManager {
    static let shared = StoryStateManager()
    private let likedKey = "likedStoryIds"

    private(set) var likedStoryIds: Set<String>

    private init() {
        let arr = UserDefaults.standard.stringArray(forKey: "likedStoryIds") ?? []
        likedStoryIds = Set(arr)
    }

    func toggleLike(_ story: Story) {
        if likedStoryIds.contains(story.sourceId) {
            likedStoryIds.remove(story.sourceId)
        } else {
            likedStoryIds.insert(story.sourceId)
        }
        UserDefaults.standard.set(Array(likedStoryIds), forKey: likedKey)
    }

    func isLiked(_ story: Story) -> Bool {
        likedStoryIds.contains(story.sourceId)
    }
}
