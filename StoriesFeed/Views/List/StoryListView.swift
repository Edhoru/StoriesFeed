import SwiftUI

struct StoryListView: View {
    @State private var vm = StoryListViewModel()
    @State private var viewerVM: StoryViewerViewModel?

    var body: some View {
        NavigationStack {
            ScrollView {
                storiesRow
                Divider()
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
        }
        .fullScreenCover(item: $viewerVM) { viewer in
            StoryViewerView(vm: viewer)
        }
        .task { await vm.loadInitialIfNeeded() }
    }

    private var storiesRow: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 14) {
                ForEach(Array(vm.users.enumerated()), id: \.element.id) { index, user in
                    Button { openViewer(at: index) } label: {
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

    private func openViewer(at index: Int) {
        let viewer = StoryViewerViewModel(users: vm.users, startUserIndex: index)
        viewer.onDismiss = { viewerVM = nil }
        viewer.onNeedMoreUsers = { [weak vm] in
            guard let vm else { return [] }
            let before = vm.users.count
            await vm.forceLoadNextPage()
            guard vm.users.count > before else { return [] }
            return Array(vm.users[before...])
        }
        viewerVM = viewer
    }
}
