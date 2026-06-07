import SwiftUI

private struct TapAndHoldModifier: ViewModifier {
    let onTap: () -> Void
    let onHoldStart: () -> Void
    let onHoldEnd: () -> Void
    private let holdThreshold: TimeInterval = 0.15

    @State private var holdTask: Task<Void, Never>?
    @State private var isHolding = false

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        guard holdTask == nil else { return }
                        holdTask = Task { @MainActor in
                            try? await Task.sleep(for: .seconds(holdThreshold))
                            guard !Task.isCancelled else { return }
                            isHolding = true
                            onHoldStart()
                        }
                    }
                    .onEnded { _ in
                        if isHolding {
                            onHoldEnd()
                        } else {
                            holdTask?.cancel()
                            onTap()
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
