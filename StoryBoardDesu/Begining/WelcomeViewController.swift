//
//  WelcomeViewController.swift
//  StoryBoardDesu
//
//  Created by Ivan Sebastian on 15/07/19.
//  Copyright © 2019 Vivien. All rights reserved.
//

import UIKit
import MultipeerConnectivity.MCPeerID


let conn = ConnectService()
class WelcomeViewController: UIViewController, UITextFieldDelegate{
    
    var playerData:playerModel!
    
    var inputRoomId: String!
   
    var roomAvailable = false
    let danceFloorVC = DanceFloorViewController()
    
    var playerInRoomPeerId:MCPeerID?
    var onFirstSearch = false
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var showtimeBtn: UIButton!

    @IBOutlet weak var txtRoomId: UITextField!
    @IBOutlet weak var lblCon: UILabel!
    
    @IBAction func btnCreateRoom(_ sender: UIButton) {
        performSegue(withIdentifier: "sendPlayerData", sender: sender)
        print("jalan langsng")
    }
    
    @IBAction func btnJoinRoom(_ sender: Any) {
        if let roomId = txtRoomId.text{
            if !roomId.isEmpty{
                
                conn.sendRoomId(roomId: roomId)
                if onFirstSearch{
                    if roomAvailable{
                        print("room is available! Yes")
                        playerData.joinRoomId(id: roomId)
                        playerData.setHostStatus(status: false)
                        conn.sendPlayerInfo(playerInfo: playerData, peer: playerInRoomPeerId!)
                        performSegue(withIdentifier: "sendPlayerData2", sender: sender)
                        
                    }else{
                        print("no room")
                        let alertController = UIAlertController(title: "Room Not Found", message: "Please input exist room or create a new room", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                onFirstSearch = true
                
                
            }else {
                let alertController = UIAlertController(title: "RoomID is required", message: "Please input the RoomID", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
   
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        conn.delegate = self 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showtimeBtn.layer.cornerRadius = 20
        
        
        
        if playerData?.gender == "m"{
            profileIcon.image = UIImage(named: "Afro1-head2@2x")
        }else{
            profileIcon.image = UIImage(named: "Afro girl")
        }
        
        txtRoomId.delegate = self
//        navigationController?.navigationBar.barTintColor = UIColor.white
//        title = ""
        
 //       danceFloorVC.delegate = self
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: RoomViewController.self, action: #selector(sendData))
 
    }
    
//    @objc func sendData(){
//        performSegue(withIdentifier: "sendPlayerData", sender: self)
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendPlayerData"{
            let roomView = segue.destination as! RoomViewController
            roomView.playerData = self.playerData
        }else if segue.identifier == "sendPlayerData2"{
            let danceFloorView = segue.destination as! DanceFloorViewController
            danceFloorView.playerData = self.playerData
        }
    }
    
}


extension WelcomeViewController: ConnectServiceDelegate{
    func connectGetStartGame(isStart: Bool) {
        
    }
       
    func connectGetRoomId(manager: ConnectService, roomid: String, fromPeer: MCPeerID) {

    }
    
    func connectGetStatus(manager: ConnectService, status: Bool, fromPeer: MCPeerID) {
        OperationQueue.main.addOperation {
            self.roomAvailable = status
            self.playerInRoomPeerId = fromPeer
            
            print(status)
        }
    }

    func connectedDevicesChanged(manager: ConnectService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.lblCon.text = "Connected Devices: \(connectedDevices)"
            if connectedDevices.count>0{
                print("Connected Devices: \(connectedDevices.count)")
            }
        }
    }
    
    func connectChanged(manager: ConnectService, playerInfo: playerModel, fromPeer: MCPeerID) {

    }
}

//extension WelcomeViewController: MatchDelegate{
//    func isMatch(match: Bool) {
//        OperationQueue.main.addOperation {
//            self.roomAvailable = match
//            print("room available!!!!!")
//        }
//
//    }
//}

