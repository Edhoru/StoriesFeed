import SwiftUI

private struct TapAndHoldModifier: ViewModifier {
    let onTap: () -> Void
    let onHoldStart: () -> Void
    let onHoldEnd: () -> Void

    @State private var holdTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content.gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard holdTask == nil else { return }
                    holdTask = Task { @MainActor in
                        try? await Task.sleep(for: .milliseconds(150))
                        guard !Task.isCancelled else { return }
                        onHoldStart()
                    }
                }
                .onEnded { _ in
                    if let task = holdTask {
                        task.cancel()
                        holdTask = nil
                        if !task.isCancelled { onHoldEnd() } else { onTap() }
                    }
                }
        )
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
