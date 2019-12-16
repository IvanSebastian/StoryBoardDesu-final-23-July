//
//  TargetPointModel.swift
//  ShowTime
//
//  Created by Randy Noel on 12/07/19.
//  Copyright © 2019 whiteHat. All rights reserved.
//

import UIKit

class TargetPointModel: UIView {

    var x : Int = 0
    var y : Int = 0
    var isTouched : Bool!
    var outliner = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        outliner.layer.borderColor = #colorLiteral(red: 0.9768887162, green: 0.1573975384, blue: 0.1336215436, alpha: 1)
        outliner.layer.borderWidth = 5
        outliner.frame.size = CGSize(width: 50, height: 50)
        outliner.layer.cornerRadius = 40
        outliner.center = self.center
        isTouched = false
        //setUpTarget(x: x, y: y)
//        UIView.animate(withDuration: 4.25, delay: 0.1, options: .curveEaseIn, animations: {
//            self.self.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
//        }) { (finished) in
//            self.self.transform = .identity
//        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpTarget(x: Int, y: Int){
        backgroundColor = .yellow
        frame.size = CGSize(width: 175, height: 175)
        layer.cornerRadius = 90
        self.alpha = 0
        layer.position = CGPoint(x: x, y: y)
    }
    
    
  
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
