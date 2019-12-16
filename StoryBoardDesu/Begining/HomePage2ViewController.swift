//
//  HomePage2ViewController.swift
//  StoryBoardDesu
//
//  Created by Ivan Sebastian on 15/07/19.
//  Copyright © 2019 Vivien. All rights reserved.
//

import UIKit
import Foundation

class HomePage2ViewController: UIViewController {

    
    @IBOutlet weak var yeahBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
   
    @IBOutlet weak var playerAvatar: UIImageView!
    
    var playerData: playerModel?

    @IBAction func clicked(_ sender: UIButton) {
        performSegue(withIdentifier: "sendPlayerData", sender: sender)
        print("Data Sended to Lobby!")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        nameLbl.text = playerData?.name
       
        playerAvatar.image = playerData?.profileImage
        yeahBtn.layer.cornerRadius = 20
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navView = segue.destination as! UINavigationController
        let welcomeView = navView.topViewController as! WelcomeViewController
        welcomeView.playerData = playerData
        
    }
    
//    fileprivate func setupText(){
//        nameLbl.text = name
//    }


}
