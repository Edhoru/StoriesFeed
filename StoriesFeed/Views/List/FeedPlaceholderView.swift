import SwiftUI

struct FeedPlaceholderView: View {
    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<6, id: \.self) { _ in
                FeedPostSkeletonView()
            }
        }
        .padding(.horizontal, 16)
    }
}

struct FeedPostSkeletonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 120, height: 12)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 80, height: 10)
                }
            }

            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.15))
                .frame(maxWidth: .infinity)
                .frame(height: 240)
        }
        .padding(.bottom, 8)
    }
}
