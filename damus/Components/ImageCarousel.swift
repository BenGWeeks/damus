//
//  ImageCarousel.swift
//  damus
//
//  Created by William Casarin on 2022-10-16.
//

import SwiftUI
import Kingfisher

// TODO: all this ShareSheet complexity can be replaced with ShareLink once we update to iOS 16
struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [URL?]
    let callback: Callback? = nil
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems as [Any],
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}

enum ImageShape {
    case square
    case landscape
    case portrait
    case unknown
}

// MARK: - Image Carousel
struct ImageCarousel: View {
    var urls: [URL]
    let evid: String
    let previews: PreviewCache
    let disable_animation: Bool

    @State private var open_sheet: Bool = false
    @State private var current_url: URL? = nil
    @State private var image_fill: ImageFill? = nil
    @State private var fillHeight: CGFloat = 350
    @State private var maxHeight: CGFloat = UIScreen.main.bounds.height * 0.85
    @State private var firstImageHeight: CGFloat = UIScreen.main.bounds.height * 0.85
    @State private var currentImageHeight: CGFloat?
    @State private var selectedIndex = 0
    
    init(previews: PreviewCache, evid: String, urls: [URL], disable_animation: Bool) {
        _open_sheet = State(initialValue: false)
        _current_url = State(initialValue: nil)
        _image_fill = State(initialValue: previews.lookup_image_meta(evid))
        self.urls = urls
        self.evid = evid
        self.previews = previews
        self.disable_animation = disable_animation
    }
    
    var filling: Bool {
        image_fill?.filling == true
    }
    
    var height: CGFloat {
        image_fill?.height ?? 100
    }

    var body: some View {
        VStack {
            TabView(selection: $selectedIndex) {
                ForEach(urls.indices, id: \.self) { index in
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.clear)
                            .overlay {
                                GeometryReader { geo in
                                    KFAnimatedImage(urls[index])
                                        .callbackQueue(.dispatch(.global(qos:.background)))
                                        .backgroundDecode(true)
                                        .imageContext(.note, disable_animation: disable_animation)
                                        .cancelOnDisappear(true)
                                        .configure { view in
                                            view.framePreloadCount = 3
                                        }
                                        .imageFill(for: geo.size, max: maxHeight, fill: fillHeight) { fill in
                                            previews.cache_image_meta(evid: evid, image_fill: fill)
                                            image_fill = fill
                                            if index == 0 {
                                                firstImageHeight = fill.height
                                                //maxHeight = firstImageHeight ?? maxHeight
                                            } else {
                                                //maxHeight = firstImageHeight ?? fill.height
                                            }
                                        }
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                        .tabItem {
                                            Text(urls[index].absoluteString)
                                        }
                                        .id(urls[index].absoluteString)
                                        .padding(0)
                                }
                            }
                            .tag(index)
                            .background(Color("DamusDarkGrey"))
                        
                        CarouselImageCounter(urls: urls, selectedIndex: $selectedIndex)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .fullScreenCover(isPresented: $open_sheet) {
                ImageView(urls: urls, disable_animation: disable_animation)
            }
            .frame(height: firstImageHeight)
            .onTapGesture {
                open_sheet = true
            }
            .tabViewStyle(PageTabViewStyle())
            
            // This is our custom carousel image indicator
            CarouselDotsView(urls: urls, selectedIndex: $selectedIndex)
        }
    }
}

// MARK: - Custom Carousel
struct CarouselDotsView: View {
    let urls: [URL]
    @Binding var selectedIndex: Int

    var body: some View {
        if urls.count > 1 {
            HStack {
                ForEach(urls.indices, id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color("DamusPurple") : Color("DamusLightGrey"))
                        .frame(width: 10, height: 10)
                        .onTapGesture {
                            selectedIndex = index
                        }
                }
            }
            .padding(.top, CGFloat(8))
            .id(UUID())
        }
    }
}

// MARK: - Carousel Image Counter
struct CarouselImageCounter: View {
    let urls: [URL]
    @Binding var selectedIndex: Int
    
    var body: some View {
        if urls.count > 1 {
            VStack {
                HStack {
                    Text("\(selectedIndex + 1)/\(urls.count)")
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .foregroundColor(Color("DamusDarkGrey"))
                                .opacity(0.40)
                        )
                        .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                    
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

// MARK: - Image Modifier
extension KFOptionSetter {
    /// Sets a block to get image size
    ///
    /// - Parameter block: The block which is used to read the image object.
    /// - Returns: `Self` value after read size
    public func imageFill(for size: CGSize, max: CGFloat, fill: CGFloat, block: @escaping (ImageFill) throws -> Void) -> Self {
        let modifier = AnyImageModifier { image -> KFCrossPlatformImage in
            let img_size = image.size
            let geo_size = size
            let fill = ImageFill.calculate_image_fill(geo_size: geo_size, img_size: img_size, maxHeight: max, fillHeight: fill)
            DispatchQueue.main.async { [block, fill] in
                try? block(fill)
            }
            return image
        }
        options.imageModifier = modifier
        return self
    }
}

public struct ImageFill {
    let filling: Bool?
    let height: CGFloat
        
    static func determine_image_shape(_ size: CGSize) -> ImageShape {
        guard size.height > 0 else {
            return .unknown
        }
        let imageRatio = size.width / size.height
        switch imageRatio {
            case 1.0: return .square
            case ..<1.0: return .portrait
            case 1.0...: return .landscape
            default: return .unknown
        }
    }
    
    static func calculate_image_fill(geo_size: CGSize, img_size: CGSize, maxHeight: CGFloat, fillHeight: CGFloat) -> ImageFill {
        let shape = determine_image_shape(img_size)

        let xfactor = geo_size.width / img_size.width
        let scaled = img_size.height * xfactor
        // calculate scaled image height
        // set scale factor and constrain images to minimum 150
        // and animations to scaled factor for dynamic size adjustment
        switch shape {
        case .portrait, .landscape:
            let filling = scaled > maxHeight
            let height = filling ? fillHeight : scaled
            return ImageFill(filling: filling, height: height)
        case .square, .unknown:
            return ImageFill(filling: nil, height: scaled)
        }
    }
}

// MARK: - Preview Provider
struct ImageCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ImageCarousel(previews: test_damus_state().previews, evid: "evid", urls: [URL(string: "https://jb55.com/red-me.jpg")!,URL(string: "https://jb55.com/red-me.jpg")!], disable_animation: false)
    }
}

