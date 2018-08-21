//
//  Extensions.swift
//  Articles
//
//  Created by Anna on 8/15/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit

extension String {
    func image() -> UIImage? {
        var image: UIImage? = nil
        if let imageUrl = URL(string: self) {
            do {
                let data =  try Data(contentsOf: imageUrl)
                image = UIImage(data:data)
            } catch {
                print(error)
            }
        }
        return image
    }
}

extension UIDevice {
    
    func iPad() -> Bool {
        return self.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? true : false
    }
    
}
