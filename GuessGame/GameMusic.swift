//
//  GameMusic.swift
//  GuessGame
//
//  Created by Richard Grave on 8/1/16.
//  Copyright © 2016 Richard Grave. All rights reserved.
//

import AVFoundation

class GameMusic {
    
    var gameMusicPlayer: AVAudioPlayer!
    
    func playMusic(_ fileName: String, type: String) {
        self.playMusic(fileName, type: type, volume: 1.0)
    }
    
    func playMusic(_ fileName: String, type: String, volume: Float) {
        let path = Bundle.main.path(forResource: fileName, ofType:type)!
        let url = URL(fileURLWithPath: path)
        
        do {
            //If music is already playing then stop it first
            stopMusic()
            
            //Play the new music
            let sound = try AVAudioPlayer(contentsOf: url)
            gameMusicPlayer = sound
            sound.numberOfLoops = -1
            sound.volume = volume
            sound.play()
        } catch {
            // no sound file with given name
        }
    }
    
    func stopMusic() {
        if gameMusicPlayer != nil {
            gameMusicPlayer.stop()
            gameMusicPlayer = nil
        }
    }
}
