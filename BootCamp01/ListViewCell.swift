//
//  ListViewCell.swift
//  BootCamp01
//
//  Created by 宍戸　俊哉 on 6/9/15.
//  Copyright (c) 2015 Shunya Shishido. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    var entryUrl: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    

        // Configure the view for the selected state
    }
    
    
    
    func content(title: String, url: String, author: String, thumbnail: String?) -> Void {
        titleLabel.text = title
        authorLabel.text = author
        entryUrl = url
        
        if thumbnail != nil {
            let imageUrl = NSURL(string: thumbnail!)
            let imageData = NSData(contentsOfURL: imageUrl!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
            let image = UIImage(data: imageData!)
            thumbnailImage.image = image
        }
    }
}
