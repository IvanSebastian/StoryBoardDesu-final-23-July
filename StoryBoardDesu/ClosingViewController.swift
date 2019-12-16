//
//  ViewController.swift
//  Closing Page
//
//  Created by Marcell Julienne on 19/07/19.
//  Copyright © 2019 Marcell Julienne. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ClosingViewController: UIViewController {

    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var viewImage1: UIView!
    @IBOutlet weak var viewImage2: UIView!
    @IBOutlet weak var viewImage3: UIView!
    
    var musicPlayerClosing = MusicPlayer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView1()
        setupView2()
        setupView3()
        setupView4()
        musicPlayerClosing.startBackgroundMusic()
        musicPlayerClosing.startCrowdCheer()
        
    }
    
    /*override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }*/
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    
    private func setupView1(){
    
        if let bundle = Bundle.main.path(forResource: "test1", ofType: "MOV") {
            
            let path = URL(fileURLWithPath: bundle)
        let player = AVPlayer(url: path)
        
            let newLayer = AVPlayerLayer(player: player)
            newLayer.frame = self.viewImage.frame
            self.viewImage.contentMode = .scaleAspectFit
            self.viewImage.layer.addSublayer(newLayer)
        
            newLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
            player.play()
       // player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        
        /*NotificationCenter.default.addObserver(self, selector: #selector(ViewController.videoViewDidPlayToEnd(_:)), name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotifications"), object: player.currentItem)
    }

    @objc func videoViewDidPlayToEnd(_ notification: Notification){
        let player: AVPlayerItem = notification.object as! AVPlayerItem
        player.seek(to: CMTime.zero)
    }*/
}
}
    
    
    private func setupView2(){
        
        if let bundle = Bundle.main.path(forResource: "test2", ofType: "MOV") {
            
            let path = URL(fileURLWithPath: bundle)
            let player = AVPlayer(url: path)
            
            let newLayer = AVPlayerLayer(player: player)
            newLayer.frame = self.viewImage1.frame
            self.viewImage1.contentMode = .scaleAspectFit
            self.viewImage1.layer.addSublayer(newLayer)
            
            newLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            player.play()
            
        }
    }
    
    private func setupView3(){
        
        if let bundle = Bundle.main.path(forResource: "test3", ofType: "MOV") {
            
            let path = URL(fileURLWithPath: bundle)
            let player = AVPlayer(url: path)
            
            let newLayer = AVPlayerLayer(player: player)
            newLayer.frame = self.viewImage2.frame
            self.viewImage2.contentMode = .scaleAspectFit
            self.viewImage2.layer.addSublayer(newLayer)
            
            newLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            player.play()
            
        }
    }
    
    private func setupView4(){
        
        if let bundle = Bundle.main.path(forResource: "test4", ofType: "MOV") {
            
            let path = URL(fileURLWithPath: bundle)
            let player = AVPlayer(url: path)
            
            let newLayer = AVPlayerLayer(player: player)
            newLayer.frame = self.viewImage3.frame
            self.viewImage3.contentMode = .scaleAspectFit
            self.viewImage3.layer.addSublayer(newLayer)
            
            newLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            player.play()
            
        }
    }
    
}
