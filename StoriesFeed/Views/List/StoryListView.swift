import SwiftUI

struct StoryListView: View {
    @State private var vm = StoryListViewModel()
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
        .task { await vm.loadInitialIfNeeded() }
    }

    private var storiesRow: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 14) {
                ForEach(vm.users) { user in
                    Button { selectedUser = user } label: {
                        StoryRingView(user: user, size: 64)
                    }
                    .buttonStyle(.plain)
                    .task { await vm.loadMoreIfNeeded(currentUser: user) }
                }
                if vm.isLoadingMore {
                    ProgressView()
                        .frame(width: 64, height: 90)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .scrollIndicators(.hidden)
    }
}
