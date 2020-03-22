//
//  Cards.swift
//  GuessGame
//
//  Created by Richard Grave on 8/3/16.
//  Copyright © 2016 Richard Grave. All rights reserved.
//

import SpriteKit

class Cards: SKScene {
    
    
    var musicPlayer: GameMusic?
    var fromStartScreen: Bool = true
    
    let fiveCards: Int = 5
    let tenCards: Int = 10
    let fifteenCards: Int = 15
    let twentyCards: Int = 20
    let twentyFiveCards: Int = 25
    
    let howManyLabel = SKLabelNode(fontNamed: "ArialHebrew")
    let fiveLabel = SKLabelNode(fontNamed: "ArialHebrew")
    let tenLabel = SKLabelNode(fontNamed: "ArialHebrew")
    let fifteenLabel = SKLabelNode(fontNamed: "ArialHebrew")
    let twentyLabel = SKLabelNode(fontNamed: "ArialHebrew")
    let twentyFiveLabel = SKLabelNode(fontNamed: "ArialHebrew")
    
    let wallpaper = SKSpriteNode(imageNamed: "MenuScreen")
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        wallpaper.zPosition = 1
        wallpaper.size = self.frame.size
        wallpaper.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        //duh, add the particles
        addParticles()
        
        //set all the parts
        setCardLabels()
        
        //Add everything to the screen
        self.addChild(wallpaper)
        self.addChild(howManyLabel)
        self.addChild(fiveLabel)
        self.addChild(tenLabel)
        self.addChild(fifteenLabel)
        self.addChild(twentyLabel)
        self.addChild(twentyFiveLabel)
        
        if !fromStartScreen {
            musicPlayer?.playMusic("Meydn_-_01_-_Interplanetary_Forest", type: "mp3")
        }
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
    
    func setCardLabels() {
        let yFramePos: CGFloat = (self.frame.maxY / 6) - 15
        
        howManyLabel.text = "Number of cards"
        howManyLabel.fontSize = 125
        howManyLabel.fontColor = UIColor.white
        howManyLabel.position = CGPoint(x:self.frame.midX, y:self.frame.maxY - yFramePos)
        howManyLabel.zPosition = 3
        
        fiveLabel.text = "\(fiveCards)"
        fiveLabel.name = "\(fiveCards)"
        fiveLabel.fontSize = 125
        fiveLabel.fontColor = UIColor.white
        fiveLabel.position = CGPoint(x:self.frame.midX, y:self.frame.maxY - (yFramePos * 2))
        fiveLabel.zPosition = 3
        
        tenLabel.text = "\(tenCards)"
        tenLabel.name = "\(tenCards)"
        tenLabel.fontSize = 125
        tenLabel.fontColor = UIColor.white
        tenLabel.position = CGPoint(x:self.frame.midX, y:self.frame.maxY - (yFramePos * 3))
        tenLabel.zPosition = 3
        
        fifteenLabel.text = "\(fifteenCards)"
        fifteenLabel.name = "\(fifteenCards)"
        fifteenLabel.fontSize = 125
        fifteenLabel.fontColor = UIColor.white
        fifteenLabel.position = CGPoint(x:self.frame.midX, y:self.frame.maxY - (yFramePos * 4))
        fifteenLabel.zPosition = 3
        
        twentyLabel.text = "\(twentyCards)"
        twentyLabel.name = "\(twentyCards)"
        twentyLabel.fontSize = 125
        twentyLabel.fontColor = UIColor.white
        twentyLabel.position = CGPoint(x:self.frame.midX, y:self.frame.maxY - (yFramePos * 5))
        twentyLabel.zPosition = 3
        
        twentyFiveLabel.text = "\(twentyFiveCards)"
        twentyFiveLabel.name = "\(twentyFiveCards)"
        twentyFiveLabel.fontSize = 125
        twentyFiveLabel.fontColor = UIColor.white
        twentyFiveLabel.position = CGPoint(x:self.frame.midX, y:self.frame.maxY - (yFramePos * 6))
        twentyFiveLabel.zPosition = 3
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Start the game with the number of chosen cards
        for touch in touches {
            let location = touch.location(in: self)
            let locNode = self.atPoint(location)
            
            //How many cards did the use want (touched on screen)
            switch locNode {
            case fiveLabel: startTheGameWithTheChosenNumberOfCards(fiveCards)
            case tenLabel: startTheGameWithTheChosenNumberOfCards(tenCards)
            case fifteenLabel: startTheGameWithTheChosenNumberOfCards(fifteenCards)
            case twentyLabel: startTheGameWithTheChosenNumberOfCards(twentyCards)
            case twentyFiveLabel: startTheGameWithTheChosenNumberOfCards(twentyFiveCards)
            default: continue
            }
        }
    }
    
    func startTheGameWithTheChosenNumberOfCards(_ numberOfCards: Int){
        let scene = GuessTheCard(fileNamed: "GuessTheCard")!
        scene.musicPlayer = self.musicPlayer
        scene.chosenNumberOfCards = numberOfCards
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 1)
        self.view?.presentScene(scene, transition: transition)
    }
    
}
