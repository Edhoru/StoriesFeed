import SwiftUI

private struct TapAndHoldModifier: ViewModifier {
    let onTap: () -> Void
    let onHoldStart: () -> Void
    let onHoldEnd: () -> Void
    private let holdThreshold: TimeInterval = 0.15
    private let tapMovementThreshold: CGFloat = 12

    @State private var holdTask: Task<Void, Never>?
    @State private var isHolding = false

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // If the finger is moving it's a swipe — cancel the hold timer.
                        if abs(value.translation.width) > tapMovementThreshold ||
                           abs(value.translation.height) > tapMovementThreshold {
                            holdTask?.cancel()
                            holdTask = nil
                            return
                        }
                        guard holdTask == nil else { return }
                        holdTask = Task { @MainActor in
                            try? await Task.sleep(for: .seconds(holdThreshold))
                            guard !Task.isCancelled else { return }
                            isHolding = true
                            onHoldStart()
                        }
                    }
                    .onEnded { value in
                        if isHolding {
                            onHoldEnd()
                        } else if isTap(value) {
                            holdTask?.cancel()
                            onTap()
                        } else {
                            holdTask?.cancel()
                        }
                        holdTask = nil
                        isHolding = false
                    }
            )
            .onDisappear {
                holdTask?.cancel()
                holdTask = nil
                isHolding = false
            }
    }

    private func isTap(_ value: DragGesture.Value) -> Bool {
        abs(value.translation.width) <= tapMovementThreshold
            && abs(value.translation.height) <= tapMovementThreshold
    }
}

extension View {
    func tapAndHold(
        onTap: @escaping () -> Void,
        onHoldStart: @escaping () -> Void,
        onHoldEnd: @escaping () -> Void
    ) -> some View {
        modifier(TapAndHoldModifier(
            onTap: onTap,
            onHoldStart: onHoldStart,
            onHoldEnd: onHoldEnd
        ))
    }
}
