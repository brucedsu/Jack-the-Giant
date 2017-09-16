//
//  AudioManager.swift
//  Jack the Giant
//
//  Created by Hejia Su on 9/10/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import AVFoundation

class AudioManager {
    
    static let instance = AudioManager()
    
    private init () {}
    
    private var audioPlayer: AVAudioPlayer?
    
    func playBGMusic() {
        let url = Bundle.main.url(forResource: "Background music", withExtension: "mp3")
        
        var err: Error?
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url!)
            audioPlayer?.numberOfLoops = -1  // Loops forever
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch let err1 {
            err = err1
        }
        
        if err != nil {
            print("We have an problem \(err!)")
        }
    }
    
    func stopBGMusic() {
        if (audioPlayer?.isPlaying)! {
            audioPlayer?.stop()
        }
    }
    
    func isAudioPlayerInitialized() -> Bool {
        return audioPlayer != nil
    }
    
}
