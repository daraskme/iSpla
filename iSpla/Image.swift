import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private var cancellable: AnyCancellable?
    
    func loadImage(fromURL url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

struct URLImage: View {
    @ObservedObject private var imageLoader: ImageLoader
    private var placeholder: Image

    init(url: URL, placeholder: Image = Image(systemName: "photo")) {
        self.imageLoader = ImageLoader()
        self.placeholder = placeholder
        self.imageLoader.loadImage(fromURL: url)
    }

    var body: some View {
        if let uiImage = imageLoader.image {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            placeholder
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

