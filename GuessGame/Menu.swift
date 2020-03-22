//
//  Menu.swift
//  GuessGame
//
//  Created by Richard Grave on 7/31/16.
//  Copyright (c) 2016 Richard Grave. All rights reserved.
//

import SpriteKit

class Menu: SKScene {
    
    var musicPlayer: GameMusic?
    
    let highscoreKey: String = "Highscore"
    let musicMenu = "Menu"
    let highscoreLabel = SKLabelNode(fontNamed: "ArialHebrew")
    let menuLabel = SKLabelNode(fontNamed: "ArialHebrew")
    let startlabel = SKLabelNode(fontNamed: "ArialHebrew")
    let wallpaper = SKSpriteNode(imageNamed: "MenuScreen")
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        wallpaper.zPosition = 1
        wallpaper.size = self.frame.size
        wallpaper.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        //duh, add particles
        addParticles()
        
        let saveHighscore: UserDefaults = UserDefaults.standard
        
        //set all parts
        let theHighscore = saveHighscore.value(forKey: highscoreKey)
        //make sure that theHigscore is not nil
        setCardLabels((theHighscore != nil ? String(theHighscore as! Int) : "0"))
        
        //Alles toevoegen aan het scherm
        self.addChild(wallpaper)
        self.addChild(menuLabel)
        self.addChild(startlabel)
        self.addChild(highscoreLabel)
        
        musicPlayer?.playMusic("Meydn_-_01_-_Interplanetary_Forest", type: "mp3")
    }
    
    func addParticles(){
        if let particles = SKEmitterNode(fileNamed: "FireFlys") {
            particles.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
            particles.particlePositionRange.dx = self.frame.maxX
            particles.particlePositionRange.dy = self.frame.maxY
            particles.zPosition = 2
            self.addChild(particles)
        }
    }
    
    func setCardLabels(_ highscore: String) {
        menuLabel.text = "Guess the card"
        menuLabel.fontSize = 90
        menuLabel.fontColor = UIColor.white
        menuLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 150)
        menuLabel.zPosition = 3
        
        startlabel.text = "Start"
        startlabel.fontSize = 90
        startlabel.fontColor = UIColor.green
        startlabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        startlabel.zPosition = 3
        
        highscoreLabel.text = "Highscore: \(highscore)"
        highscoreLabel.fontSize = 125
        highscoreLabel.fontColor = UIColor.white
        highscoreLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 250)
        highscoreLabel.zPosition = 3
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Start the game
        for touch in touches {
            let location = touch.location(in: self)
            let locNode = self.atPoint(location)
            
            //Do this if the start label is touched
            if locNode == startlabel {
                let scene = Cards(fileNamed: "NumberOfCards")!
                scene.musicPlayer = self.musicPlayer
                scene.fromStartScreen = true
                let transition = SKTransition.moveIn(with: .right, duration: 1)
                self.view?.presentScene(scene, transition: transition)
            }
            
            //Reset highscore if highscore label is touched
            if locNode == highscoreLabel {
                let saveHighscore: UserDefaults = UserDefaults.standard
                
                //set highscore to 0
                saveHighscore.setValue(0, forKey: highscoreKey)
                
                highscoreLabel.text = "Highscore: \(0)"
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
