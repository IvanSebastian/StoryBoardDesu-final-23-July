//
//  TargetPointViewController.swift
//  ShowTime
//
//  Created by Randy Noel on 12/07/19.
//  Copyright © 2019 whiteHat. All rights reserved.
//

import UIKit
import CoreGraphics
import AVKit
import AVFoundation

class TargetPointViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var countDownView: UIView!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var char1View: UIImageView!
    @IBOutlet weak var char2View: UIImageView!
    @IBOutlet weak var char3View: UIImageView!
    @IBOutlet weak var char4View: UIImageView!
    
    var music = MusicPlayer()
    var timer: Timer!
    var timerLeft:Double = 0.0
    var pointResult :Int = 0
    var tempTimer:Double = 0.0
    var count = 0
    
    var countDown:[UIImage] = [#imageLiteral(resourceName: "countdown_0"),#imageLiteral(resourceName: "countdown_1"),#imageLiteral(resourceName: "countdown_2"),#imageLiteral(resourceName: "countdown_3")]
    var char:[UIImage] = [#imageLiteral(resourceName: "Char1-head"), #imageLiteral(resourceName: "Char3-Head"), #imageLiteral(resourceName: "Char2-head"), #imageLiteral(resourceName: "Char4-Head")]
    
    var moves:[CGPoint]=[]
    var moves2:[CGPoint]=[]
    var idx = 0
    var target = TargetPointModel()
    var target2 = TargetPointModel()
    var prevTarget = TargetPointModel()
    var prevTarget2 = TargetPointModel()
    var isHeadDetected = false
    var isFeetDetected = false
    
    private var handsRec: CGRect!
    
    @IBOutlet weak var lblReady: UILabel!
    @IBOutlet weak var lblReadyPlayer1: UILabel!
    @IBOutlet weak var lblReadyPlayer2: UILabel!
    @IBOutlet weak var lblReadyPlayer3: UILabel!
    @IBOutlet weak var lblReadyPlayer4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        target.setUpTarget(x: 80, y: 80)
        target2.setUpTarget(x: 100, y: 100)
        
        //ANIMATION COUNTDOWN GET READY,3,2,1
        let imageView0 = UIImageView(image: countDown[0])
        countDownView.addSubview(imageView0)
        imageView0.alpha = 1
        UIView.animate(withDuration: 3, delay: 0.5, options: .curveEaseInOut, animations: {
            imageView0.alpha = 0
            imageView0.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { cb in
            let imageView1 = UIImageView(image: self.countDown[1])
            self.countDownView.addSubview(imageView1)
            self.music.startSoundEffect1()
            imageView1.alpha = 1
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                imageView1.alpha = 0
                imageView1.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: { cb in
                let imageView2 = UIImageView(image: self.countDown[2])
                self.countDownView.addSubview(imageView2)
                self.music.startSoundEffect1()
                imageView2.alpha = 1
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                    imageView2.alpha = 0
                    imageView2.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }, completion: { cb in
                    let imageView3 = UIImageView(image: self.countDown[3])
                    self.countDownView.addSubview(imageView3)
                    self.music.startSoundEffect1()
                    imageView3.alpha = 1
                    UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                        imageView3.alpha = 0
                        imageView3.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    }, completion: nil)
                })
            })
        })
        
        //PLAYER'S CHARACTER
        let player1 = UIImageView(image: char[0])
        char1View.addSubview(player1)
        let player2 = UIImageView(image: char[1])
        char2View.addSubview(player2)
        let player3 = UIImageView(image: char[2])
        char3View.addSubview(player3)
        let player4 = UIImageView(image: char[3])
        char4View.addSubview(player4)
        
        
        target.isHidden = true
        target2.isHidden = true
        view.addSubview(target)
        view.addSubview(target2)
        timingForTarget()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    
    func TargetDetection(jointView: DrawingJoint){
        if Constant.pointLabels.count == jointView.bodyPoints.count{
            if isFullBodyDetected(jointView: jointView){
                if isHandOnTarget(jointView: jointView) && !target.isTouched {
                    
                    pointResult += 1
                    print("on Target! Total Point: \(pointResult)")
                    target.isTouched = false
                    target2.isTouched = false
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lblReady.alpha = 0
        UIView.animate(withDuration: 3, delay: 2.5, options: .curveEaseInOut, animations: {
        self.lblReady.alpha = 1
        }, completion: {_ in
            self.lblReady.text = ""
        })
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    func isHandOnTarget(jointView: DrawingJoint)->Bool{
        let size = jointView.bounds.size
        for (index, data) in jointView.bodyPoints.enumerated(){
            if index == 7 || index == 4 {
                if let bp = jointView.bodyPoints[index], bp.maxConfidence > 0.7{
                    let p = bp.maxPoint
                    let point = CGPoint(x: p.x * size.width , y: p.y * size.height)
                    
                    handsRec = CGRect(origin: point, size: CGSize(width: 60.0, height: 60.0))
                    
                    
                    if target.frame.intersects(handsRec) && target2.frame.intersects(handsRec){
                        print(target.center)
                        print(handsRec.origin)
                        lblReady.text = "Perfect"
                        lblReady.textColor = #colorLiteral(red: 1, green: 0.9554565549, blue: 0, alpha: 1)
                        target.isTouched = true
                        target2.isTouched = true
                        
                        lblReadyPlayer1.text = ""
                        lblReadyPlayer1.textColor = #colorLiteral(red: 1, green: 0.9554565549, blue: 0, alpha: 1)
                        
                        lblReadyPlayer2.text = "Perfect"
                        lblReadyPlayer2.textColor = #colorLiteral(red: 1, green: 0.9554565549, blue: 0, alpha: 1)
                        
                        lblReadyPlayer3.text = "Perfect"
                        lblReadyPlayer3.textColor = #colorLiteral(red: 1, green: 0.9554565549, blue: 0, alpha: 1)
                        
                        lblReadyPlayer4.text = "Perfect"
                        lblReadyPlayer4.textColor = #colorLiteral(red: 1, green: 0.9554565549, blue: 0, alpha: 1)
                        
                        count += 1
                        labelCount.text = String(count * 10)
                        return true
                    }else{
                        lblReady.text = "Catch Up"
                        lblReady.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                        
                        lblReadyPlayer1.text = ""
                        lblReadyPlayer1.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                        
                        lblReadyPlayer2.text = "Catch Up!"
                        lblReadyPlayer2.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                        
                        lblReadyPlayer3.text = "Catch Up!"
                        lblReadyPlayer3.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                        
                        lblReadyPlayer4.text = "Catch Up!"
                        lblReadyPlayer4.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                    }
                }
            }
        }
        return false
    }
    
    
    func isFullBodyDetected(jointView: DrawingJoint) -> Bool{
       
            if let head = jointView.bodyPoints[0]{
                if head.maxConfidence>=1{
                    isHeadDetected = true
                }else if head.maxConfidence<1{
                    isHeadDetected = false
                }
            }
            
            if let feet = jointView.bodyPoints[10]{
                if feet.maxConfidence>=1{
                    isFeetDetected = true
                }else if feet.maxConfidence<1{
                    isFeetDetected = false
                }
            }
        
        if isHeadDetected && isFeetDetected{
            return true
        }
        return false
    }
    
    
    
    func callMoveNum(num: Int){
        switch num {
        case 1: moves.removeAll()
            moves2.removeAll()
            //moves for user's left hand
            moves.append(CGPoint(x: 70, y: 300))
            moves.append(CGPoint(x: 210, y: 380))
            moves.append(CGPoint(x: 125, y: 240))
            moves.append(CGPoint(x: 130, y: 240))
            moves.append(CGPoint(x: 150, y: 345))
            moves.append(CGPoint(x: 100, y: 275)) //
            moves.append(CGPoint(x: 225, y: 360))
            moves.append(CGPoint(x: 140, y: 390))
            moves.append(CGPoint(x: 250, y: 365))
            moves.append(CGPoint(x: 120, y: 260))
            moves.append(CGPoint(x: 180, y: 300))
            moves.append(CGPoint(x: 145, y: 275))
            moves.append(CGPoint(x: 150, y: 350))
            moves.append(CGPoint(x: 155, y: 365))
            moves.append(CGPoint(x: 150, y: 390))
            moves.append(CGPoint(x: 110, y: 260))
            moves.append(CGPoint(x: 165, y: 385))
            moves.append(CGPoint(x: 160, y: 350))
            moves.append(CGPoint(x: 135, y: 350))
            moves.append(CGPoint(x: 180, y: 400))
            moves.append(CGPoint(x: 150, y: 300))
        
            //moves2 is for user's right hand
            moves2.append(CGPoint(x: 125, y: 360))
            moves2.append(CGPoint(x: 275, y: 265))
            moves2.append(CGPoint(x: 220, y: 380))
            moves2.append(CGPoint(x: 250, y: 240))
            moves2.append(CGPoint(x: 255, y: 295))
            moves2.append(CGPoint(x: 230, y: 265)) //
            moves2.append(CGPoint(x: 290, y: 360))
            moves2.append(CGPoint(x: 225, y: 315))
            moves2.append(CGPoint(x: 260, y: 335))
            moves2.append(CGPoint(x: 270, y: 260))
            moves2.append(CGPoint(x: 215, y: 360))
            moves2.append(CGPoint(x: 240, y: 360))
            moves2.append(CGPoint(x: 240, y: 350))
            moves2.append(CGPoint(x: 235, y: 365))
            moves2.append(CGPoint(x: 235, y: 390))
            moves2.append(CGPoint(x: 250, y: 365))
            moves2.append(CGPoint(x: 245, y: 330))
            moves2.append(CGPoint(x: 245, y: 350))
            moves2.append(CGPoint(x: 220, y: 330))
            moves2.append(CGPoint(x: 265, y: 335))
            moves2.append(CGPoint(x: 275, y: 345))
            
            
//            print("ini gerakan 1")
            
     
        default:
            return
        }
    }
    
    
    func setNewTargetCenter(){
        
        
        prevTarget = target
        prevTarget2 = target2
        if idx < moves.count{
            target.center = moves[idx]
            target2.center = moves2[idx]
            idx += 1
        }else{
            idx = 0
            target.center = moves[idx]
            target2.center = moves2[idx]
            idx += 1
        }
        print(idx)
    }
    
    
    func timingForTarget(){
        music.startBackgroundMusic()
        playVideo()
        callMoveNum(num: 1)
        timerLeft = music.audioPlayer!.duration
        tempTimer = music.audioPlayer!.duration
        target.isHidden = false
        target2.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 0.55, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        
       
    }

    @objc func onTimerFires(){
        timerLeft -= 0.55
        //print("\(timerLeft) seconds")
        
        if tempTimer-timerLeft > 4.0{
            tempTimer = timerLeft
            self.setNewTargetCenter()
            print("set new center")
//            UIView.animate(withDuration: 2.5, delay: 0, options: .curveEaseInOut, animations: {
//                self.target.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
//                self.target2.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
//                self.prevTarget.center = self.target.center
//                self.prevTarget2.center = self.target2.center
//
//            }) { (finished) in
//                self.target.transform = CGAffineTransform.init(scaleX: 1, y: 1)
//                self.target2.transform = CGAffineTransform.init(scaleX: 1, y: 1)
//                print("animated")
//
//            }
        }
        
        if timerLeft <= 0{
            timer.invalidate()
            performSegue(withIdentifier: "segueToFinal", sender: self)
            timer = nil
        }
        
    }
    
    private func playVideo(){
        let path = URL(fileURLWithPath: Bundle.main.path(forResource: "MC2 final", ofType: "MOV")!)
        let player = AVPlayer(url: path)
        let newLayer = AVPlayerLayer(player: player)
        newLayer.frame = self.videoView.frame
        self.videoView.layer.addSublayer(newLayer)
        newLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoView.alpha = 0.75
        
        player.play()
        print("berhasil")
    }


    
}




