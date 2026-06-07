import SwiftUI

struct StoryViewerView: View {
    @Bindable var vm: StoryViewerViewModel
    @State private var dragOffset: CGFloat = 0
    @State private var isHolding = false

    private let dismissThreshold: CGFloat = 100
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
                    onHoldStart: {
                        isHolding = true
                        vm.pause()
                    },
                    onHoldEnd: {
                        isHolding = false
                        vm.resume()
                    }
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
        .simultaneousGesture(viewerDragGesture)
        .onAppear { vm.start() }
        .onDisappear {
            isHolding = false
            vm.stop()
        }
    }

    private var viewerDragGesture: some Gesture {
        DragGesture(minimumDistance: 30)
            .onChanged { value in
                guard !isHolding, isVerticalDismissSwipe(value) else { return }
                dragOffset = value.translation.height
                if !vm.isPaused { vm.pause() }
            }
            .onEnded { value in
                guard !isHolding else { return }

                if isHorizontalUserSwipe(value) {
                    dragOffset = 0
                    if value.translation.width < 0 {
                        vm.goToNextUser()
                    } else {
                        vm.goToPreviousUser()
                    }
                } else if isVerticalDismissSwipe(value), value.translation.height > dismissThreshold {
                    withAnimation(.easeIn(duration: 0.2)) { dragOffset = 1000 }
                    vm.onDismiss?()
                } else if dragOffset != 0 {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        dragOffset = 0
                    }
                    vm.resume()
                }
            }
    }

    private func isVerticalDismissSwipe(_ value: DragGesture.Value) -> Bool {
        value.translation.height > 0
            && value.translation.height > abs(value.translation.width)
    }

    private func isHorizontalUserSwipe(_ value: DragGesture.Value) -> Bool {
        abs(value.translation.width) > userSwipeThreshold
            && abs(value.translation.width) > abs(value.translation.height)
    }

    private var dragScale: CGFloat {
        max(0.88, 1.0 - dragOffset / 1400)
    }
}
