//
//  RoomViewController.swift
//  StoryBoardDesu
//
//  Created by Ivan Sebastian on 16/07/19.
//  Copyright © 2019 Vivien. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {

    
    @IBOutlet weak var roomNumber: UILabel!
    
    var playerData:playerModel?
    var newRoom: RoomModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createRoomId()
        getRoomId()
    }
    
    func createRoomId(){
        let randomNumber =  Int.random(in: 1000...9999)
        roomNumber.text = String(randomNumber)
        if let id = roomNumber.text {
            newRoom = RoomModel(id: id)
            playerData?.joinRoomId(id: id)
        }
    }
    
    func getRoomId()->String{
        print("connection ambil data room")
        print(newRoom.id)
        print(playerData?.roomId)
        return newRoom.id!
    }
    
    
    @IBAction func btnInRoom(_ sender: Any) {
        print(playerData?.name)
        if let playerRoom = playerData?.roomId{
            print("player room available!")
            if !playerRoom.isEmpty{
                playerData?.setHostStatus(status: true)
                performSegue(withIdentifier: "sendPlayerData3", sender: sender)
            }
            else{
                print("player Room is not set!")
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let danceFloorView = segue.destination as! DanceFloorViewController
        danceFloorView.playerData = playerData
    }
 

}
