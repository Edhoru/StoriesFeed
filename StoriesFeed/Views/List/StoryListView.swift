import SwiftUI

struct StoryListView: View {
    let users: [StoryUser]

    var body: some View {
        NavigationStack {
            ScrollView {
                storiesRow
                    .padding(.vertical, 12)
                Divider()
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var storiesRow: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 14) {
                ForEach(users) { user in
                    VStack(spacing: 6) {
                        CachedAsyncImage(url: user.avatarURL) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Circle().fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                        Text(user.username)
                            .font(.caption2)
                            .lineLimit(1)
                    }
                    .frame(width: 80)
                }
            }
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
    }
}
