import SwiftUI

struct StoryViewerView: View {
    @Bindable var vm: StoryViewerViewModel
    @State private var dragOffset: CGFloat = 0
    private let dismissStartThreshold: CGFloat = 24
    private let dismissThreshold: CGFloat = 100

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
                .scaleEffect(dragScale)
                .ignoresSafeArea()
        )
        .background(Color.black.ignoresSafeArea())
        .offset(y: dragOffset)
        .simultaneousGesture(dismissDragGesture)
        .onAppear { vm.start() }
        .onDisappear { vm.stop() }
    }

    private var dismissDragGesture: some Gesture {
        DragGesture(minimumDistance: dismissStartThreshold)
            .onChanged { value in
                guard isDismissDrag(value) else { return }
                dragOffset = value.translation.height
                if !vm.isPaused { vm.pause() }
            }
            .onEnded { value in
                guard isDismissDrag(value) else {
                    if dragOffset != 0 {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            dragOffset = 0
                        }
                    }
                    return
                }

                if value.translation.height > dismissThreshold {
                    withAnimation(.easeIn(duration: 0.2)) { dragOffset = 1000 }
                    vm.onDismiss?()
                } else {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        dragOffset = 0
                    }
                    vm.resume()
                }
            }
    }

    private func isDismissDrag(_ value: DragGesture.Value) -> Bool {
        value.translation.height > dismissStartThreshold
            && value.translation.height > abs(value.translation.width)
    }

    private var dragScale: CGFloat {
        max(0.88, 1.0 - dragOffset / 1400)
    }
}
