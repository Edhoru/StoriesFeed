import SwiftUI

struct StoryRingView: View {
    let user: StoryUser
    let size: CGFloat

    var body: some View {
        VStack(spacing: 6) {
            CachedAsyncImage(url: user.avatarURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Circle().fill(Color.gray.opacity(0.3))
            }
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(Color.blue, lineWidth: 3)
                    .padding(-3)
            }

            Text(user.username)
                .font(.caption2)
                .lineLimit(1)
        }
        .frame(width: size + 16)
    }
}
