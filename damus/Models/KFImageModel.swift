//
//  KFImageModel.swift
//  damus
//
//  Created by Oleg Abalonski on 1/11/23.
//

import Foundation
import Kingfisher
import SVGKit

class KFImageModel: ObservableObject {
    
    let url: URL?
    let fallbackUrl: URL?
    let processor: ImageProcessor
    let serializer: CacheSerializer
    
    @Published var refreshID = ""
    
    init(url: URL?, fallbackUrl: URL?, maxByteSize: Int, downsampleSize: CGSize) {
        self.url = url
        self.fallbackUrl = fallbackUrl
        self.processor = CustomImageProcessor(maxSize: maxByteSize, downsampleSize: downsampleSize)
        self.serializer = CustomCacheSerializer(maxSize: maxByteSize, downsampleSize: downsampleSize)
    }
    
    func refresh() -> Void {
        DispatchQueue.main.async {
            self.refreshID = UUID().uuidString
        }
    }
    
    func cache(_ image: UIImage, forKey key: String) -> Void {
        KingfisherManager.shared.cache.store(image, forKey: key, processorIdentifier: processor.identifier) { _ in
            self.refresh()
        }
    }
    
    func downloadFailed() -> Void {
        guard let url = url, let fallbackUrl = fallbackUrl else { return }
        
        DispatchQueue.global(qos: .background).async {
            KingfisherManager.shared.downloader.downloadImage(with: fallbackUrl) { result in
                
                var fallbackImage: UIImage {
                    switch result {
                    case .success(let imageLoadingResult):
                        return imageLoadingResult.image
                    case .failure(let error):
                        print(error)
                        return UIImage()
                    }
                }
                
                self.cache(fallbackImage, forKey: url.absoluteString)
            }
        }
    }
}

struct CustomImageProcessor: ImageProcessor {
    
    let maxSize: Int
    let downsampleSize: CGSize
    
    let identifier = "com.damus.customimageprocessor"
    
    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
    //func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo, completion: @escaping (KFCrossPlatformImage?) -> Void) {
    //However, this doesn't confirm to the protocol.
        
        switch item {
        case .image(_):
            // This case will never run
            return DefaultImageProcessor.default.process(item: item, options: options)
        case .data(let data):
            
            var returnImage = DefaultImageProcessor.default.process(item: item, options: options)
            
            // Detect NSFW images (test on @npub189dj7es2ft44w0f3ncum4yaze4flvtnyzcu0u77gekeymv038x2sa63a0t for example)
            //if #available(iOS 12.0, *) {
                let detector = NSFWDetector.shared
                guard let image = DefaultImageProcessor.default.process(item: item, options: options) else { return DefaultImageProcessor.default.process(item: item, options: options) }
            //let image = { result in
                detector.check(image: image, completion: { result in
                    switch result {
                    case let .success(nsfwConfidence: confidence):
                        print("NSFW confidence = ", confidence)
                        if confidence > 0.5 {
                            // 😱🙈😏
                            // return KingfisherWrapper.image(data: data, options: options)?.kf.blurred(withRadius: 5)
                            returnImage = image.kf.blurred(withRadius: 5)
                        } else {
                            // ¯\_(ツ)_/¯
                            returnImage = image
                        }
                    default:
                        returnImage = image
                    }
                })
            //}
            
            // Handle large image size
            if data.count > maxSize {
                return KingfisherWrapper.downsampledImage(data: data, to: downsampleSize, scale: options.scaleFactor)
            }
            
            // Handle SVG image
            if let svgImage = SVGKImage(data: data), let image = svgImage.uiImage {
                return image.kf.scaled(to: options.scaleFactor)
            }
            
            //return DefaultImageProcessor.default.process(item: item, options: options)
            return returnImage
        }
    }
}

struct CustomCacheSerializer: CacheSerializer {
    
    let maxSize: Int
    let downsampleSize: CGSize

    func data(with image: Kingfisher.KFCrossPlatformImage, original: Data?) -> Data? {
        return DefaultCacheSerializer.default.data(with: image, original: original)
    }

    func image(with data: Data, options: Kingfisher.KingfisherParsedOptionsInfo) -> Kingfisher.KFCrossPlatformImage? {
        if data.count > maxSize {
            return KingfisherWrapper.downsampledImage(data: data, to: downsampleSize, scale: options.scaleFactor)
        }

        return DefaultCacheSerializer.default.image(with: data, options: options)
    }
}
