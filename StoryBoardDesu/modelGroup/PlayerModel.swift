//
//  PlayerModel.swift
//  newTEstMPC
//
//  Created by Randy Noel on 18/07/19.
//  Copyright © 2019 whiteHat. All rights reserved.
//

import Foundation
import UIKit

class playerModel{
    
    var profileImage: UIImage?
    var name:String?
    var status:Bool = false
    var gender:String?
    var roomId: String?
    
    init(playerProfileImg: UIImage, name: String, gender: String) {
        self.profileImage = playerProfileImg
        self.name = name
        self.gender = gender
    }
    
    func joinRoomId(id : String){
        self.roomId = id
    }
    
    func outRoomId(){
        self.roomId = ""
    }
    
    func setHostStatus(status: Bool){
        self.status = status
    }
    
}


    
