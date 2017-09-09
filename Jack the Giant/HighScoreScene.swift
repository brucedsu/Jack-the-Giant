//
//  HighScoreScene.swift
//  Jack the Giant
//
//  Created by Hejia Su on 9/8/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import SpriteKit

class HighScoreScene: SKScene {
    
    var backButton: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        let highScoreLabel = self.childNode(withName: "Score Label") as! SKLabelNode
        highScoreLabel.fontName = "Blow"
        highScoreLabel.fontSize = 48
        
        let coinLabel = self.childNode(withName: "Coin Label") as! SKLabelNode
        coinLabel.fontName = "Blow"
        highScoreLabel.fontSize = 48
        
        backButton = self.childNode(withName: "Back Button") as? SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if nodes(at: location).contains(backButton!) {
                let scene = MainMenuScene(fileNamed: "MainMenuScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(
                    scene!,
                    transition: SKTransition.doorsCloseVertical(withDuration: 1))
            }
        }
    }
    
}
