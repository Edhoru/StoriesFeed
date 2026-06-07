import SwiftUI

struct StoryRingView: View {
    let user: StoryUser
    let seenStories: [Bool]
    let size: CGFloat

    private var storyCount: Int { user.stories.count }
    private var seenCount: Int { seenStories.filter { $0 }.count }
    private var ringSize: CGFloat { size + 14 }
    private let gap: Double = 0.04

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                ringOverlay

                CachedAsyncImage(url: user.avatarURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.3))
                }
                .frame(width: size, height: size)
                .clipShape(Circle())
            }
            .frame(width: ringSize, height: ringSize)

            Text(user.username)
                .font(.caption2)
                .lineLimit(1)
        }
        .frame(width: ringSize + 2)
        .accessibilityLabel("\(user.username), \(seenCount) of \(storyCount) stories seen")
    }

    private var ringOverlay: some View {
        Canvas { ctx, canvasSize in
            let center = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)
            let radius = min(canvasSize.width, canvasSize.height) / 2 - 2
            let arcSpan = (1.0 - gap * Double(storyCount)) / Double(storyCount)

            for i in 0..<storyCount {
                let start = Double(i) * (arcSpan + gap) - 0.25
                let end = start + arcSpan
                var path = Path()
                path.addArc(center: center,
                            radius: radius,
                            startAngle: .init(degrees: start * 360),
                            endAngle: .init(degrees: end * 360),
                            clockwise: false)
                let color: Color = seenStories[i] ? .gray.opacity(0.5) : .blue
                ctx.stroke(path, with: .color(color),
                           style: StrokeStyle(lineWidth: 3, lineCap: .round))
            }
        }
        .frame(width: ringSize, height: ringSize)
    }
}
