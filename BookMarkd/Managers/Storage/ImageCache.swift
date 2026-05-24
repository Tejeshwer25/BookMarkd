//
//  ImageCache.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 13/02/26.
//

import UIKit

actor CachedImageLoaderActor {
    private var cache = NSCache<NSString, UIImage>()
    
    static let shared = CachedImageLoaderActor()
    private init() {}
    
    func load(from url: URL?) async -> UIImage? {
        guard let url else {
            return nil
        }
        
        if let cached = self.image(for: url) {
            return cached
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                self.set(uiImage, for: url)
                return uiImage
            }
        } catch {
            print("Image load failed:", error)
        }
        
        return nil
    }
    
    private func image(for url: URL) -> UIImage? {
        cache.object(forKey: url.absoluteString as NSString)
    }
    
    private func set(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as NSString)
    }
}
