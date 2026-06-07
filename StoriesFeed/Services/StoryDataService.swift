import Foundation

final class StoryDataService: Sendable {
    static let shared = StoryDataService()
    private let allUsers: [StoryUser]
    private let pageSize = 10

    private init() {
        guard
            let url = Bundle.main.url(forResource: "stories", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let users = try? JSONDecoder().decode([StoryUser].self, from: data)
        else { allUsers = []; return }
        allUsers = users
    }

    @concurrent
    func fetchUsers(page: Int) async -> [StoryUser] {
        guard !allUsers.isEmpty else { return [] }
        let startIndex = (page * pageSize) % allUsers.count
        var result: [StoryUser] = []

        for i in 0..<pageSize {
            let source = allUsers[(startIndex + i) % allUsers.count]
            let user = StoryUser(
                id: "\(source.id)-p\(page)i\(i)",
                sourceId: source.sourceId,
                username: source.username,
                avatarSeed: source.avatarSeed,
                stories: source.stories.map {
                    Story(id: "\($0.id)-p\(page)i\(i)",
                          sourceId: $0.sourceId,
                          imageSeed: $0.imageSeed,
                          caption: $0.caption)
                }
            )
            result.append(user)
        }

        try? await Task.sleep(for: .milliseconds(300))
        return result
    }
}
