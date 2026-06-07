import SwiftUI

struct StoryProgressBarsView: View {
    let totalStories: Int
    let currentIndex: Int
    let progress: CGFloat

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalStories, id: \.self) { index in
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.white.opacity(0.4))
                        Capsule()
                            .fill(Color.white)
                            .frame(width: geo.size.width * fillAmount(for: index))
                    }
                }
                .frame(height: 2)
            }
        }
        .padding(.horizontal, 8)
    }

    private func fillAmount(for index: Int) -> CGFloat {
        if index < currentIndex { return 1 }
        if index == currentIndex { return progress }
        return 0
    }
}

struct StoryTopBarView: View {
    let user: StoryUser
    let totalStories: Int
    let currentStoryIndex: Int
    let progress: CGFloat
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            StoryProgressBarsView(
                totalStories: totalStories,
                currentIndex: currentStoryIndex,
                progress: progress
            )
            .padding(.top, 12)

            HStack(spacing: 10) {
                CachedAsyncImage(url: user.avatarURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.4))
                }
                .frame(width: 34, height: 34)
                .clipShape(Circle())
                .overlay { Circle().stroke(Color.white.opacity(0.6), lineWidth: 1) }

                Text(user.username)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .shadow(radius: 2)

                Spacer()

                Button("Close", systemImage: "xmark", action: onDismiss)
                    .labelStyle(.iconOnly)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.black.opacity(0.3))
                    .clipShape(Circle())
            }
            .padding(.horizontal, 12)
        }
        .padding(.bottom, 4)
    }
}
