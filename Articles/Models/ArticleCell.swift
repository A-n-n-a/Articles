//
//  HistoryCell.swift
//  PicRecognition
//
//  Created by Anna on 8/4/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit
import CoreData

class ArticleCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var pictureWidth: NSLayoutConstraint!
    @IBOutlet weak var pictureHeight: NSLayoutConstraint!
    
    var record: NSManagedObject! {
        didSet {
            setUpCell()
        }
    }
    
    func setUpCell() {
        
        setImageSize()
        
        self.backgroundColor = UIColor.clear
        
        let imageKey = UIDevice.current.iPad() ? "imageMediumPath" : "imageThumbPath"
        
        if  let record = record,
            let imagePath = record.value(forKey: imageKey) as? String,
            let title = record.value(forKey: "title") as? String {
            
            if let image = Cache.fetchCache(path: title) {
                self.picture.image = image
            } else {
                self.picture.image = imagePath.image()
            }
            self.title.text = title
        }
    }
    
    func setImageSize() {
        if UIDevice.current.iPad() {
            pictureWidth.constant = 250
            pictureHeight.constant = pictureWidth.constant
        }
    }
}
