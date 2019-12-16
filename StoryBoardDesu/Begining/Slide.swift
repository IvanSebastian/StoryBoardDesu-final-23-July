//
//  Slide.swift
//  ShowTime
//
//  Created by Ivan Sebastian on 10/07/19.
//  Copyright © 2019 whiteHat. All rights reserved.
//

import UIKit

@IBDesignable
class Slide: UIView {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelDesc: UILabel!
    

    @IBInspectable var firstColor:UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    
    @IBInspectable var secondColor:UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var isVertical: Bool = true {
        didSet{
            updateView()
        }
    }
    
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        
        layer.colors = [firstColor,secondColor].map{$0.cgColor}
        
    
    }

}
