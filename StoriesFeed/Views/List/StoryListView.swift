import SwiftUI

struct StoryListView: View {
    let users: [StoryUser]
    @State private var selectedUser: StoryUser?

    var body: some View {
        NavigationStack {
            ScrollView {
                storiesRow
                Divider()
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
        }
        .fullScreenCover(item: $selectedUser) { user in
            StoryViewerView(user: user, onDismiss: { selectedUser = nil })
        }
    }

    private var storiesRow: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 14) {
                ForEach(users) { user in
                    Button { selectedUser = user } label: {
                        StoryRingView(user: user, size: 64)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .scrollIndicators(.hidden)
    }
}
