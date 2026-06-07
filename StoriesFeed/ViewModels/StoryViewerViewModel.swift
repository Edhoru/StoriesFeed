import Foundation
import SwiftUI

@MainActor
@Observable
final class StoryViewerViewModel {
    private(set) var users: [StoryUser]
    private(set) var currentUserIndex: Int
    private(set) var currentStoryIndex: Int = 0
    private(set) var progress: CGFloat = 0

    var onDismiss: (() -> Void)?
    var onNeedMoreUsers: (() async -> [StoryUser])?

    private var progressTask: Task<Void, Never>?
    private let storyDuration: TimeInterval = 5.0

    var currentUser: StoryUser { users[currentUserIndex] }
    var currentStory: Story { currentUser.stories[currentStoryIndex] }

    init(users: [StoryUser], startUserIndex: Int) {
        self.users = users
        self.currentUserIndex = startUserIndex
    }

    func start() { startProgress() }

    func stop() { progressTask?.cancel() }

    // MARK: - Private

    private func startProgress() {
        progressTask?.cancel()
        let base = Double(progress)
        let startDate = Date()

        progressTask = Task { @MainActor [weak self] in
            while true {
                try? await Task.sleep(for: .seconds(1.0 / 30.0))
                guard !Task.isCancelled, let self else { return }
                let elapsed = Date().timeIntervalSince(startDate)
                let next = base + elapsed / storyDuration
                if next >= 1.0 {
                    progress = 1.0
                    advanceStory()
                    return
                }
                progress = CGFloat(next)
            }
        }
    }

    private func advanceStory() {
        progressTask?.cancel()
        if currentStoryIndex < currentUser.stories.count - 1 {
            currentStoryIndex += 1
            progress = 0
            startProgress()
        } else {
            advanceToNextUser()
        }
    }

    private func advanceToNextUser() {
        guard currentUserIndex < users.count - 1 else {
            Task { @MainActor [weak self] in
                guard let self else { return }
                let newUsers = await onNeedMoreUsers?() ?? []
                if newUsers.isEmpty { onDismiss?(); return }
                users.append(contentsOf: newUsers)
                advanceToNextUser()
            }
            return
        }
        currentUserIndex += 1
        currentStoryIndex = 0
        progress = 0
        startProgress()
    }
}

extension StoryViewerViewModel: @MainActor Identifiable {
    var id: ObjectIdentifier { ObjectIdentifier(self) }
}
