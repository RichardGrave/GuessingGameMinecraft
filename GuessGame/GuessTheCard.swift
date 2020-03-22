//
//  GuessTheCard.swift
//  GuessGame
//
//  Created by Richard Grave on 7/31/16.
//  Copyright (c) 2016 Richard Grave. All rights reserved.
//

import SpriteKit

class GuessTheCard: SKScene {
    
    var musicPlayer: GameMusic?
    
    var chosenNumberOfCards: Int?
    
    var guessedCorrectly: Int = 0
    var guessedWrong: Int = 0
    var numberOfCardsLeft: Int = 0
    
    let card_size: CGFloat = 0.25
    
    let guessedCorrectlyLabel = SKLabelNode(fontNamed: "ArialHebrew")
    let cardsLeftLabel = SKLabelNode(fontNamed: "ArialHebrew")
    let stopLabel = SKLabelNode(fontNamed: "ArialHebrew")
    
    //All the cards that we need for the guessing game
    let cards: [String] = ["CowCard", "BeeCard", "PigCard", "SheepCard"]
    
    let cow_card = SKSpriteNode(imageNamed: "CowCard")
    let bee_card = SKSpriteNode(imageNamed: "BeeCard")
    let pig_card = SKSpriteNode(imageNamed: "PigCard")
    let sheep_card = SKSpriteNode(imageNamed: "SheepCard")
    
    //Default CowCard to initialize the secret_image. Gets randomly changed later when the game really begins
    let secret_image = SKSpriteNode(imageNamed: "CowCard")
    let backside_guess_card = SKSpriteNode(imageNamed: "GuessCard")
    
    let particles = SKEmitterNode(fileNamed: "MagicTouch")
    
    let wallpaper = SKSpriteNode(imageNamed: "GamePlayBackground")
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        wallpaper.zPosition = 1
        wallpaper.size = self.frame.size
        wallpaper.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        //Set all the parts
        newGame()
        setCardLabels()
        setCardName()
        setTheCardSize(card_size)
        positionTheCards()
        resetForNextCard()
        
        //does what it says
        addParticles()
        
        //Add everything to the screen
        self.addChild(wallpaper)
        self.addChild(cow_card)
        self.addChild(bee_card)
        self.addChild(pig_card)
        self.addChild(sheep_card)
        self.addChild(secret_image)
        self.addChild(backside_guess_card)
        self.addChild(guessedCorrectlyLabel)
        self.addChild(cardsLeftLabel)
        self.addChild(stopLabel)
        
        //Play nice game music
        musicPlayer?.playMusic("Meyd_-_02_-_Elk", type: "mp3", volume: 0.25)
    }
    
    func setCardLabels() {
        cardsLeftLabel.text = "Cards left: \(numberOfCardsLeft)"
        cardsLeftLabel.fontSize = 35
        cardsLeftLabel.fontColor = UIColor.white
        cardsLeftLabel.position = CGPoint(x:self.frame.minX + 10, y:self.frame.maxY - 40)
        cardsLeftLabel.zPosition = 2
        cardsLeftLabel.horizontalAlignmentMode = .left
        
        guessedCorrectlyLabel.text = "Guessed correctly: \(guessedCorrectly)"
        guessedCorrectlyLabel.fontSize = 35
        guessedCorrectlyLabel.fontColor = UIColor.white
        guessedCorrectlyLabel.position = CGPoint(x:self.frame.minX + 10, y:self.frame.maxY - 80)
        guessedCorrectlyLabel.zPosition = 2
        guessedCorrectlyLabel.horizontalAlignmentMode = .left
        
        stopLabel.text = "Stop"
        stopLabel.fontSize = 40
        stopLabel.fontColor = UIColor.red
        stopLabel.position = CGPoint(x:self.frame.maxX - 175, y:self.frame.maxY - 80)
        stopLabel.zPosition = 2
        stopLabel.horizontalAlignmentMode = .left
    }
    
    func addParticles(){
        particles!.particlePositionRange.dx = 200
        particles!.particlePositionRange.dy = 200
        particles!.zPosition = 3
        particles!.isHidden = true
        
        self.addChild(particles!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //What did the player touch in the game
        for touch in touches {
            let location = touch.location(in: self)
            let locNode = self.atPoint(location)
            
            //Check if the touched is the correct one. Or if stop is touched, stop the game
            switch locNode {
            case cow_card: checkTheCard(cards[0], touchLocation: location)
            case bee_card: checkTheCard(cards[1], touchLocation: location)
            case pig_card: checkTheCard(cards[2], touchLocation: location)
            case sheep_card: checkTheCard(cards[3], touchLocation: location)
            case stopLabel: stopTheGame()
            default: continue
            }
        }
    }
    
    func stopTheGame() {
        let scene = Menu(fileNamed: "Menu")!
        scene.musicPlayer = self.musicPlayer
        let transition = SKTransition.doorsCloseHorizontal(withDuration: 1)
        self.view?.presentScene(scene, transition: transition)
    }
    
    func newGame() {
        //Reset counters
        guessedCorrectly = 0
        guessedWrong = 0
        numberOfCardsLeft = chosenNumberOfCards!
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    //Check if the player has guessed the correct card
    func checkTheCard(_ cardName: String, touchLocation: CGPoint) {
        particles!.position = touchLocation
        particles!.isHidden = false
        particles!.resetSimulation()
        
        backside_guess_card.isHidden = true
        secret_image.isHidden = false
        
        //Guess is correct if the cardname matches the secret image name.
        if cardName == secret_image.name {
            playSound(true)
            guessedCorrectly += 1
            guessedCorrectlyLabel.text = "Guessed correctly: \(guessedCorrectly)"
        }
        else{
            playSound(false)
        }
        
        numberOfCardsLeft -= 1
        cardsLeftLabel.text = "Cards left: \(numberOfCardsLeft)"
        
        if numberOfCardsLeft > 0 {
            //Temporarily disable the touch action.
            self.isUserInteractionEnabled = false
            
            //do this after a small delay
            runAfterDelay(1.5){
                self.resetForNextCard()
                self.particles!.isHidden = true
            }
        }
        else {
            //End of game, go to score
            let scene = Score(fileNamed: "Score")!
            scene.musicPlayer = self.musicPlayer
            scene.guessedCorrectly = guessedCorrectly
            let transition = SKTransition.doorsCloseHorizontal(withDuration: 1)
            self.view?.presentScene(scene, transition: transition)
        }
    }
    
    //Sounds to play for correct guess (yay) or wrong guess (fart)
    func playSound(_ geraden: Bool) {
        let soundToPlay = !geraden ? SKAction.playSoundFileNamed("fart",waitForCompletion:false) :
                                     SKAction.playSoundFileNamed("Yay",waitForCompletion:false)
        run(soundToPlay)
    }
    
    func resetForNextCard(){
        //Select a new secret card
        let randomKaart = cards[Int(arc4random_uniform(UInt32(cards.count)))]
        
        secret_image.texture = SKTexture(imageNamed: randomKaart)
        secret_image.name = randomKaart
        secret_image.isHidden = true
        backside_guess_card.isHidden = false
        
        //Enable the touch actions again (disabled in the method 'checkTheCard')
        self.isUserInteractionEnabled = true
    }
    
    func runAfterDelay(_ delay: TimeInterval, block: @escaping ()->()) {
        let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: block)
    }
    
    //set correct size for the cards
    func setTheCardSize(_ size: CGFloat) {
        cow_card.xScale = size
        cow_card.yScale = size
        cow_card.zPosition = 2
        cow_card.isUserInteractionEnabled = false
        
        bee_card.xScale = size
        bee_card.yScale = size
        bee_card.zPosition = 2
        
        pig_card.xScale = size
        pig_card.yScale = size
        pig_card.zPosition = 2
        
        sheep_card.xScale = size
        sheep_card.yScale = size
        sheep_card.zPosition = 2
        
        secret_image.xScale = size * 2
        secret_image.yScale = size * 2
        secret_image.zPosition = 2
        
        backside_guess_card.xScale = size * 2
        backside_guess_card.yScale = size * 2
        backside_guess_card.zPosition = 2
    }
    
    //calculate the positions for all the cards
    func positionTheCards(){
        let maxCardX = self.frame.width / 4
        let startPositionCard = (maxCardX - cow_card.size.width)
        
        cow_card.position = CGPoint(x: startPositionCard, y: (frame.height / 4))
        bee_card.position = CGPoint(x: maxCardX + startPositionCard, y: (frame.height / 4))
        pig_card.position = CGPoint(x: (maxCardX * 2) + startPositionCard, y: (frame.height / 4))
        sheep_card.position = CGPoint(x: (maxCardX * 3) + startPositionCard, y: (frame.height / 4))
        
        secret_image.position = CGPoint(x: self.frame.midX, y: self.frame.height / 1.5)
        backside_guess_card.position = secret_image.position
        
        backside_guess_card.isHidden = false
        secret_image.isHidden = true
        
        //Set random first
        let secretCard = cards[Int(arc4random_uniform(UInt32(cards.count)))]
        secret_image.texture = SKTexture(imageNamed: secretCard)
    }
    
    func setCardName(){
        cow_card.name = "CowCard"
        bee_card.name = "BeeCard"
        pig_card.name = "PigCard"
        sheep_card.name = "SheepCard"
        backside_guess_card.name = "GuessCard"
        secret_image.name = "CowCard"
    }
}
