//
//  Cache.swift
//  Articles
//
//  Created by Anna on 8/17/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit

class Cache {
    
    static let imageCache = NSCache<NSString, UIImage>()
    
    static func cacheImage(_ image: UIImage, key: String) {
        Cache.imageCache.setObject(image, forKey: key as NSString)
    }
    
    static func fetchCache(path: String) -> UIImage?  {
        return Cache.imageCache.object(forKey: path as NSString)
    }
    
    static func removeAllObjects() {
        Cache.imageCache.removeAllObjects()
    }
}
