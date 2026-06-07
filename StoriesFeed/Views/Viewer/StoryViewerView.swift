import SwiftUI

struct StoryViewerView: View {
    let user: StoryUser
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text(user.username)
                .foregroundStyle(.white)
                .font(.title.bold())
            VStack {
                HStack {
                    Spacer()
                    Button("Close", systemImage: "xmark", action: onDismiss)
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.white)
                        .padding()
                }
                Spacer()
            }
        }
    }
}
