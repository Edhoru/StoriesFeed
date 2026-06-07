import Foundation

@MainActor
@Observable
final class StoryListViewModel {
    private(set) var users: [StoryUser] = []
    private(set) var isLoadingMore = false
    private var currentPage = 0
    private let service = StoryDataService.shared

    func loadInitialIfNeeded() async {
        guard users.isEmpty else { return }
        await loadNextPage()
    }

    func loadMoreIfNeeded(currentUser: StoryUser) async {
        guard !isLoadingMore,
              let index = users.firstIndex(where: { $0.id == currentUser.id }),
              index >= users.count - 4
        else { return }
        await loadNextPage()
    }

    func forceLoadNextPage() async {
        guard !isLoadingMore else { return }
        await loadNextPage()
    }

    private func loadNextPage() async {
        isLoadingMore = true
        let newUsers = await service.fetchUsers(page: currentPage)
        users.append(contentsOf: newUsers)
        currentPage += 1
        isLoadingMore = false
    }
}
