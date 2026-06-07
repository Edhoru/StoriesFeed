import SwiftUI

struct StoryViewerView: View {
    @Bindable var vm: StoryViewerViewModel
    private let userSwipeThreshold: CGFloat = 70

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                StoryTopBarView(
                    user: vm.currentUser,
                    totalStories: vm.currentUser.stories.count,
                    currentStoryIndex: vm.currentStoryIndex,
                    progress: vm.progress,
                    onDismiss: { vm.onDismiss?() }
                )
                StoryTapZonesView(
                    onTapBack: { vm.tapBackward() },
                    onTapForward: { vm.tapForward() },
                    onHoldStart: { vm.pause() },
                    onHoldEnd: { vm.resume() }
                )
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            StoryImageLayerView(story: vm.currentStory)
                .ignoresSafeArea()
        )
        .background(Color.black.ignoresSafeArea())
        .simultaneousGesture(userSwipeGesture)
        .onAppear { vm.start() }
        .onDisappear { vm.stop() }
    }

    private var userSwipeGesture: some Gesture {
        DragGesture(minimumDistance: 30)
            .onEnded { value in
                guard isHorizontalUserSwipe(value) else { return }

                if value.translation.width < 0 {
                    vm.goToNextUser()
                } else {
                    vm.goToPreviousUser()
                }
            }
    }

    private func isHorizontalUserSwipe(_ value: DragGesture.Value) -> Bool {
        abs(value.translation.width) > userSwipeThreshold
            && abs(value.translation.width) > abs(value.translation.height)
    }
}
