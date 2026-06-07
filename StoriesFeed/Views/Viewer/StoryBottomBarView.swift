import SwiftUI

struct StoryBottomBarView: View {
    let story: Story
    let isLiked: Bool
    let isAnimating: Bool
    let seenDate: Date?
    let onLike: () -> Void
    let onPause: () -> Void
    let onResume: () -> Void

    @State private var showSeenPopover = false

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
            VStack(spacing: 12) {
                if let seenDate {
                    Button("Seen", systemImage: "eye", action: { showSeenPopover = true })
                        .labelStyle(.iconOnly)
                        .font(.title3)
                        .foregroundStyle(.white)
                        .frame(width: 48, height: 48)
                        .background(Color.black.opacity(0.25))
                        .clipShape(Circle())
                        .popover(isPresented: $showSeenPopover) {
                            Text(relativeSeenLabel(from: seenDate))
                                .font(.subheadline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .presentationCompactAdaptation(.none)
                        }
                        .onChange(of: showSeenPopover) { _, isShowing in
                            isShowing ? onPause() : onResume()
                        }
                }

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
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    private func relativeSeenLabel(from date: Date) -> String {
        let days = Calendar.current.dateComponents(
            [.day],
            from: Calendar.current.startOfDay(for: date),
            to: Calendar.current.startOfDay(for: .now)
        ).day ?? 0

        switch days {
        case 0:        return "Seen today"
        case 1:        return "Seen a day ago"
        case 2...6:    return "Seen \(days) days ago"
        case 7:        return "Seen a week ago"
        case 8...29:   return "Seen over a week ago"
        case 30...364: return "Seen over a month ago"
        default:       return "Seen over a year ago"
        }
    }
}
