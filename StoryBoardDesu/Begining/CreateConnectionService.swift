//
//  CreateConnectionService.swift
//  StoryBoardDesu
//
//  Created by Randy Noel on 20/07/19.
//  Copyright © 2019 Vivien. All rights reserved.
//

import Foundation
import MultipeerConnectivity


class ConnectService : NSObject{

    private let ConnectServiceType = "example-player"
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    
    private let serviceBrowser : MCNearbyServiceBrowser
    
    var delegate : ConnectServiceDelegate?
    var imgDataVar:NSData!
    
    var isStart = false
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: ConnectServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: ConnectServiceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    func setGameStart(isStart: String, peers:[MCPeerID]){
        NSLog("@", "Start The Game")
        if session.connectedPeers.count > 0{
            do{
                let data = Data(isStart.utf8)
                try session.send(data, toPeers: peers, with: .reliable)
            }catch{
                print(error)
            }
        }
    }
    
    
    func sendRoomId(roomId: String){
        NSLog("@", "send typed room id to other player")
        if session.connectedPeers.count > 0{
            do{
                let data = Data(roomId.utf8)
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }catch{
                print(error)
            }
        }
    }
    
    func sendRoomStatus(isAvailable: String, peer: MCPeerID){
        NSLog("@", "send typed room id to other player")
        if session.connectedPeers.count > 0{
            do{
                let data = Data(isAvailable.utf8)
                try session.send(data, toPeers: [peer], with: .reliable)
            }catch{
                print(error)
            }
        }
    }
    
    func sendPlayerInfo(playerInfo: playerModel, peer: MCPeerID){
        NSLog("%@", "sendPlayer: \(playerInfo.name) to \(peer) peers")
        let imgData = playerInfo.profileImage?.pngData()
        let myDict:[String : Any] = ["name":"\(playerInfo.name!)", "img":imgData, "gen":"\(playerInfo.gender)", "roomId":"\(playerInfo.roomId)"]
        
        if session.connectedPeers.count > 0{
            do{
                let data = try NSKeyedArchiver.archivedData(withRootObject: myDict, requiringSecureCoding: false)
                try session.send(data, toPeers: [peer], with: .reliable)
                print("Data sended!")
            }catch{
                print(error)
            }
        }
    }
}

extension ConnectService : MCNearbyServiceAdvertiserDelegate{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
}

extension ConnectService : MCNearbyServiceBrowserDelegate{
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        
        NSLog("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
}

protocol ConnectServiceDelegate{
    func connectedDevicesChanged(manager : ConnectService, connectedDevices: [String])
    func connectChanged(manager : ConnectService, playerInfo : playerModel, fromPeer: MCPeerID)
    func connectGetRoomId(manager: ConnectService, roomid: String, fromPeer: MCPeerID)
    func connectGetStatus(manager: ConnectService, status: Bool, fromPeer: MCPeerID)
    func connectGetStartGame(isStart: Bool)
}


extension ConnectService : MCSessionDelegate{
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map{$0.displayName})
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        
        if data.count < 10{
            do{
                let data = try String(decoding: data, as: UTF8.self)
                print("datadtatdtatdatd \(data)")
                if data == "true" || data == "false"{
                    if data == "true"{
                        self.delegate?.connectGetStatus(manager: self, status: true, fromPeer: peerID)
                    }else{
                        self.delegate?.connectGetStatus(manager: self, status: false, fromPeer: peerID)
                    }
                }else if data == "start"{
                    print("Start the game!")
                    isStart = true
                    self.delegate?.connectGetStartGame(isStart: isStart)
                }else{
                    self.delegate?.connectGetRoomId(manager: self, roomid: data, fromPeer: peerID)
                    print("accepted roomid")
                }
                
            }catch{
                print("fail get room id! try to unarchive playerInfo")
            }
        }else{
        
        do{
            let newDict = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! NSDictionary
            print("newDict")
            let inputRoomId = newDict["roomId"] as! String
            
            
            let img = UIImage(data: newDict["img"] as! Data)!
            
            
            let name = newDict["name"] as! String
            let gen = newDict["gen"] as! String
            let otherPlayer = playerModel(playerProfileImg: img, name: name, gender: gen)
            otherPlayer.joinRoomId(id: inputRoomId)
            print("Accept!")
            
            self.delegate?.connectChanged(manager: self, playerInfo: otherPlayer, fromPeer: peerID)
            
            
        }catch{
            print("ini error!")
            print("error")
        }
        }

        //let str = String(data: data, encoding: .utf8)
        //self.delegate?.colorChanged(manager: self, playerInfo: str!)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
}

