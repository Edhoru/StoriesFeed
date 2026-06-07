import SwiftUI

struct ContentView: View {
    @State private var users: [StoryUser] = []

    var body: some View {
        StoryListView(users: users)
            .task {
                guard
                    let url = Bundle.main.url(forResource: "stories", withExtension: "json"),
                    let data = try? Data(contentsOf: url),
                    let decoded = try? JSONDecoder().decode([StoryUser].self, from: data)
                else { return }
                users = decoded
            }
    }
}
