//
//  Score.swift
//  GuessGame
//
//  Created by Richard Grave on 7/31/16.
//  Copyright (c) 2016 Richard Grave. All rights reserved.
//

import SpriteKit

class Score: SKScene {
    
    var guessedCorrectly: Int = 0
    var minYAs: CGFloat = 150
    var musicPlayer: GameMusic?
    
    let highscoreKey: String = "Highscore"
    let scoreLabel = SKLabelNode(fontNamed: "ArialHebrew")
    let scoreGetalLabel = SKLabelNode(fontNamed: "ArialHebrew")
    let playAgainLabel = SKLabelNode(fontNamed: "ArialHebrew")
    let excellentLabel = SKLabelNode(fontNamed: "ArialHebrew")
    let stopLabel = SKLabelNode(fontNamed: "ArialHebrew")
    let wallpaper = SKSpriteNode(imageNamed: "Won")
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        wallpaper.zPosition = 1
        wallpaper.size = self.frame.size
        wallpaper.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        excellentLabel.isHidden = true
        
        //Database save for highscores
        let saveHighscore: UserDefaults = UserDefaults.standard
        
        var isNewHighscore: Bool = false
        
        if guessedCorrectly != 0 {
            //set all the parts
            let theHighscore = saveHighscore.value(forKey: highscoreKey)
            //Make sure the last score is not nil
            let previousScore: Int = (theHighscore != nil ? theHighscore as! Int : 0)
            
            //Check if score is higher than previous time
            if guessedCorrectly > previousScore {
                isNewHighscore = true
                saveHighscore.setValue(guessedCorrectly, forKey: highscoreKey)
                minYAs = 250
                excellentLabel.isHidden = false
                wallpaper.texture = SKTexture(imageNamed: "Highscore")
            }
            
            musicPlayer?.playMusic("Meydn_-_Fae", type: "mp3")
        } else {
            addParticles("SadRain")
            wallpaper.texture = SKTexture(imageNamed: "LostRain")
            musicPlayer?.playMusic("Meydn_-_05_-_Rain", type: "mp3")
        }
        
        //add everything to the screen
        self.addChild(wallpaper)
        self.addChild(scoreLabel)
        self.addChild(scoreGetalLabel)
        self.addChild(playAgainLabel)
        self.addChild(stopLabel)
        self.addChild(excellentLabel)
        
        //We have to do this last or the labels will not be shown correctly
        setCardLabels(isNewHighscore)
    }
    
    func addParticles(_ particleName: String){
        if let particles = SKEmitterNode(fileNamed: particleName) {
            particles.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 200)
            particles.particlePositionRange.dx = self.frame.maxX
            particles.particlePositionRange.dy = self.frame.maxY
            particles.zPosition = 2
            self.addChild(particles)
        }
    }
    
    func setCardLabels(_ isNewHighscore: Bool) {
        scoreLabel.text = (isNewHighscore ? "New Highscore" : "Your score is")
        scoreLabel.fontSize = 120
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 150)
        scoreLabel.zPosition = 3
        
        scoreGetalLabel.text = "\(guessedCorrectly)"
        scoreGetalLabel.fontSize = 250
        scoreGetalLabel.fontColor = UIColor.white
        scoreGetalLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 30)
        scoreGetalLabel.zPosition = 3
        
        excellentLabel.text = "Excellent"
        excellentLabel.fontSize = 120
        excellentLabel.fontColor = UIColor.white
        excellentLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 125)
        excellentLabel.zPosition = 3
        
        playAgainLabel.text = "New"
        playAgainLabel.fontSize = 80
        playAgainLabel.fontColor = UIColor.green
        playAgainLabel.position = CGPoint(x:self.frame.midX - 150, y:self.frame.midY - minYAs)
        playAgainLabel.zPosition = 3
        
        stopLabel.text = "Stop"
        stopLabel.fontSize = 80
        stopLabel.fontColor = UIColor.red
        stopLabel.position = CGPoint(x:self.frame.midX + 150, y:self.frame.midY - minYAs)
        stopLabel.zPosition = 3
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let locNode = self.atPoint(location)
            
            //Did the player touch 'new' for another game or does the player want to 'stop'
            if locNode == playAgainLabel {
                let scene = Cards(fileNamed: "NumberOfCards")!
                scene.musicPlayer = self.musicPlayer
                scene.fromStartScreen = false
                let transition = SKTransition.doorsOpenHorizontal(withDuration: 1)
                self.view?.presentScene(scene, transition: transition)
            }
            if locNode == stopLabel {
                let scene = Menu(fileNamed: "Menu")!
                scene.musicPlayer = self.musicPlayer
                let transition = SKTransition.doorsCloseHorizontal(withDuration: 1)
                self.view?.presentScene(scene, transition: transition)
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
