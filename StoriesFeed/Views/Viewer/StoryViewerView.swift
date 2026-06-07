import SwiftUI

struct StoryViewerView: View {
    @Bindable var vm: StoryViewerViewModel

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
        .onAppear { vm.start() }
        .onDisappear { vm.stop() }
    }
}
