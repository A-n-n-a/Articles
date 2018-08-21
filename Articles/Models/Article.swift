//
//  Article.swift
//  Articles
//
//  Created by Anna on 8/15/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit

struct Article {
    
    var id: Int
    var title: String
    var imageMediumPath: String
    var imageThumbPath: String
    var urlPath: String
    
    init(id: Int, title: String, imageMediumPath: String, imageThumbPath: String, urlPath: String) {
        self.id = id
        self.title = title
        self.imageMediumPath = imageMediumPath
        self.imageThumbPath = imageThumbPath
        self.urlPath = urlPath
    }
    
    func imageMedium() -> UIImage? {
        return imageMediumPath.image()
    }
    
    func imageThumb() -> UIImage? {
        return imageThumbPath.image()
    }
    
    func url() -> URL? {
        return URL(string: urlPath)
    }
}
