import Foundation

struct StoryUser: Identifiable, Codable, Sendable {
    let id: String
    let username: String
    let avatarSeed: Int
    let stories: [Story]

    var avatarURL: URL {
        URL(string: "https://picsum.photos/seed/avatar\(avatarSeed)/200/200")!
    }
}

struct Story: Identifiable, Codable, Sendable {
    let id: String
    let imageSeed: Int
    let caption: String

    var imageURL: URL {
        URL(string: "https://picsum.photos/seed/\(imageSeed)/600/1067")!
    }
}
