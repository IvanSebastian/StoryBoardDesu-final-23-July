//
//  RoomModel.swift
//  StoryBoardDesu
//
//  Created by Randy Noel on 18/07/19.
//  Copyright © 2019 Vivien. All rights reserved.
//

import Foundation

class RoomModel{
    var id: String?
    var players:[playerModel]!
    
    init(id: String) {
        self.id = id
    }
    
    func addplayerToRoom(player : playerModel){
        players.append(player)
    }
    
}
