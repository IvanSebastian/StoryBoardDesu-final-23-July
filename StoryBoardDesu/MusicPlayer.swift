//
//  MusicPlayer.swift
//  ShowTime
//
//  Created by Randy Noel on 16/07/19.
//  Copyright © 2019 whiteHat. All rights reserved.
//

import Foundation
import AVFoundation

class MusicPlayer {
    static let shared = MusicPlayer()
    var audioPlayer: AVAudioPlayer?
    var audioPlayerSoundEffect: AVAudioPlayer?
    
    func startBackgroundMusic(){
        if let bundle = Bundle.main.path(forResource: "MC2 Gameplay Audio", ofType: "mp3"){
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else {return}
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }catch{
                print(error)
            }
        }
    }
    
    func startSoundEffect1(){
        if let bundle1 = Bundle.main.path(forResource: "arrowImpact", ofType: "wav"){
            let soundEffect1 = NSURL(fileURLWithPath: bundle1)
            do{
                audioPlayerSoundEffect = try AVAudioPlayer(contentsOf: soundEffect1 as URL)
                guard let audioPlayer1 = audioPlayerSoundEffect else {return}
                audioPlayer1.prepareToPlay()
                audioPlayer1.play()
            }catch{
                print(error)
            }
        }
    }

    func startCrowdCheer(){
        if let bundle2 = Bundle.main.path(forResource: "crowd cheer", ofType: "mp3"){
            let soundEffect2 = NSURL(fileURLWithPath: bundle2)
            do{
                audioPlayerSoundEffect = try AVAudioPlayer(contentsOf: soundEffect2 as URL)
                guard let audioPlayer2 = audioPlayerSoundEffect else {return}
                audioPlayer2.prepareToPlay()
                audioPlayer2.play()
            }catch{
                print(error)
            }
        }
    }
    
    func stopBackgroundMusic(){
        guard let audioPlayer = audioPlayer else {return}
        audioPlayer.stop()
    }
    
}
