import Foundation

struct StoryUser: Identifiable, Codable, Sendable {
    let id: String
    let sourceId: String
    let username: String
    let avatarSeed: Int
    let stories: [Story]

    init(id: String, sourceId: String, username: String, avatarSeed: Int, stories: [Story]) {
        self.id = id
        self.sourceId = sourceId
        self.username = username
        self.avatarSeed = avatarSeed
        self.stories = stories
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        sourceId = id
        username = try c.decode(String.self, forKey: .username)
        avatarSeed = try c.decode(Int.self, forKey: .avatarSeed)
        stories = try c.decode([Story].self, forKey: .stories)
    }

    private enum CodingKeys: String, CodingKey {
        case id, username, avatarSeed, stories
    }

    var avatarURL: URL {
        URL(string: "https://picsum.photos/seed/avatar\(avatarSeed)/200/200")!
    }
}

struct Story: Identifiable, Codable, Sendable {
    let id: String
    let sourceId: String
    let imageSeed: Int
    let caption: String

    init(id: String, sourceId: String, imageSeed: Int, caption: String) {
        self.id = id
        self.sourceId = sourceId
        self.imageSeed = imageSeed
        self.caption = caption
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        sourceId = id
        imageSeed = try c.decode(Int.self, forKey: .imageSeed)
        caption = try c.decode(String.self, forKey: .caption)
    }

    private enum CodingKeys: String, CodingKey {
        case id, imageSeed, caption
    }

    var imageURL: URL {
        URL(string: "https://picsum.photos/seed/\(imageSeed)/600/1067")!
    }
}
