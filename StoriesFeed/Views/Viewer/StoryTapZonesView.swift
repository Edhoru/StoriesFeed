import SwiftUI

struct StoryTapZonesView: View {
    let onTapBack: () -> Void
    let onTapForward: () -> Void
    let onHoldStart: () -> Void
    let onHoldEnd: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Color.clear
                .contentShape(Rectangle())
                .tapAndHold(onTap: onTapBack,
                            onHoldStart: onHoldStart,
                            onHoldEnd: onHoldEnd)
                .containerRelativeFrame(.horizontal, count: 3, span: 1, spacing: 0)

            Color.clear
                .contentShape(Rectangle())
                .tapAndHold(onTap: onTapForward,
                            onHoldStart: onHoldStart,
                            onHoldEnd: onHoldEnd)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
