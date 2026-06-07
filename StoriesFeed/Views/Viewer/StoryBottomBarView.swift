import SwiftUI

struct StoryBottomBarView: View {
    let story: Story
    let isLiked: Bool
    let isAnimating: Bool
    let onLike: () -> Void

    var body: some View {
        HStack(alignment: .bottom) {
            if !story.caption.isEmpty {
                Text(story.caption)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
                    .shadow(radius: 3)
                    .lineLimit(2)
            }
            Spacer()
            Button(isLiked ? "Unlike" : "Like",
                   systemImage: isLiked ? "heart.fill" : "heart",
                   action: onLike)
                .labelStyle(.iconOnly)
                .font(.title2)
                .foregroundStyle(isLiked ? .red : .white)
                .scaleEffect(isAnimating ? 1.35 : 1.0)
                .animation(.spring(response: 0.25, dampingFraction: 0.5),
                           value: isAnimating)
                .frame(width: 48, height: 48)
                .background(Color.black.opacity(0.25))
                .clipShape(Circle())
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}
