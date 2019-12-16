//
//  PlayerCollectionViewCell.swift
//  StoryBoardDesu
//
//  Created by Randy Noel on 19/07/19.
//  Copyright © 2019 Vivien. All rights reserved.
//

import UIKit

struct cellModel {
    let image: UIImage
    let name: String
}

class PlayerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with model: cellModel){
        image.image = model.image
        lblName.text = model.name
    }
    
}
