//
//  GameViewController.swift
//  GuessGame
//
//  Created by Richard Grave on 7/31/16.
//  Copyright (c) 2016 Richard Grave. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    let gameMusicPlayer = GameMusic()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = Menu(fileNamed:"Menu") {
            scene.musicPlayer = gameMusicPlayer
            // Configure the view.
            let skView = self.view as! SKView
//            skView.showsFPS = true
//            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
    }
    
    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
            return .landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }

    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(false)
//        gameMusicPlayer.stopMusic()
//    }
}
