//
//  ViewController.swift
//  RoomView
//
//  Created by Marcell Julienne on 16/07/19.
//  Copyright © 2019 Marcell Julienne. All rights reserved.
//

import UIKit
import MultipeerConnectivity.MCPeerID


struct CustomData{
    var title: String
    var backgroundImage: UIImage
    var url: String
}


class DanceFloorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    //var delegate: MatchDelegate? = nil
    
    var data:[cellModel]=[]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var playerData:playerModel!
    
    var otherPlayer:playerModel?
    
    var requestRoom:String?
    var requestPeerId: MCPeerID?
    var ownConnectedPeers:[MCPeerID]?
    
    @IBOutlet weak var floorNum: UILabel!
    
    @IBOutlet weak var readyBtn: UIButton!
    
    
    @IBAction func btnStart(_ sender: Any) {
       // if let cons = ownConnectedPeers{
            //conn.setGameStart(isStart: "start", peers: cons)
            print("clicked!")
            self.performSegue(withIdentifier: "startGame", sender: sender)
       // }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conn.delegate = self
        
        if let player = playerData{
            floorNum.text = player.roomId
            data.append(cellModel(image: player.profileImage!, name: player.name!))
        }
       
//        if !playerData.status {
//            readyBtn.isHidden = true
//            //readyBtn.isUserInteractionEnabled = false
//        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "PlayerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlayerCollectionViewCell")
        
        collectionView.reloadData()
        
    }
    
    

    
    override func viewDidAppear(_ animated: Bool) {
//        if let otherPlayer = otherPlayer{
//            data.append(cellModel(image: otherPlayer.profileImage!, name: otherPlayer.name!))
//            print("set other player")
//        }
    }
    
    func checkRoom()->Bool{
        print("Tettdvfhgvdfjkh : \(requestRoom)")
        if let myRoom = playerData.roomId, myRoom != nil{
            if myRoom == requestRoom{
                return true
            }
        }
        return false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellModel", for: indexPath) as! PlayerCollectionViewCell
        cell.configure(with: data[indexPath.row])
        return cell
    }
    
 
}

//protocol MatchDelegate{
//    func isMatch(match: Bool)
//}

extension DanceFloorViewController : ConnectServiceDelegate{
    func connectGetStartGame(isStart: Bool) {
        OperationQueue.main.addOperation {
            if isStart{
                self.performSegue(withIdentifier: "startGame", sender: self)
            }
        }
    }
    
    func connectGetRoomId(manager: ConnectService, roomid: String, fromPeer: MCPeerID) {
        OperationQueue.main.addOperation {
            self.requestRoom = roomid
            self.requestPeerId = fromPeer
            
            if self.checkRoom(){
                conn.sendRoomStatus(isAvailable: "true", peer: self.requestPeerId!)
                conn.sendPlayerInfo(playerInfo: self.playerData, peer: self.requestPeerId!)
                //self.connectedPeers?.append(self.requestPeerId!)
                print("send status of roomavailable!")
            }
        }
        
    }
    
    func connectedDevicesChanged(manager: ConnectService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
           
            
            
        }
       
    }
    
    func connectChanged(manager: ConnectService, playerInfo: playerModel, fromPeer: MCPeerID) {
        OperationQueue.main.addOperation {
            print("accept player information")
            self.data.append(cellModel(image: playerInfo.profileImage!, name: playerInfo.name!))
            self.ownConnectedPeers?.append(fromPeer)
            self.collectionView.reloadData()
            
            
        }
    }
    
    func connectGetStatus(manager: ConnectService, status: Bool, fromPeer: MCPeerID) {
        
    }
    
    
}
