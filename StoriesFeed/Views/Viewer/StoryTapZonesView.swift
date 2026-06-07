import SwiftUI

struct StoryTapZonesView: View {
    let onTapBack: () -> Void
    let onTapForward: () -> Void
    let onHoldStart: () -> Void
    let onHoldEnd: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Color.clear
                .containerRelativeFrame(.horizontal) { size, _ in size * 0.33 }
                .tapAndHold(onTap: onTapBack,
                            onHoldStart: onHoldStart,
                            onHoldEnd: onHoldEnd)

            Color.clear
                .containerRelativeFrame(.horizontal) { size, _ in size * 0.67 }
                .tapAndHold(onTap: onTapForward,
                            onHoldStart: onHoldStart,
                            onHoldEnd: onHoldEnd)
        }
    }
}
