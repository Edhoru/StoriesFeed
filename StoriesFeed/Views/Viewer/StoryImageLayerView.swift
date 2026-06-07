import SwiftUI

struct StoryImageLayerView: View {
    let story: Story

    var body: some View {
        CachedAsyncImage(url: story.imageURL) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Color.black
        }
        .id(story.id)
    }
}
