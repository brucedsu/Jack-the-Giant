//
//  HighScoreScene.swift
//  Jack the Giant
//
//  Created by Hejia Su on 9/8/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import SpriteKit

class HighScoreScene: SKScene {
    
    override func didMove(to view: SKView) {
        let highScoreLabel = self.childNode(withName: "Score Label") as! SKLabelNode
        highScoreLabel.fontName = "Blow"
        highScoreLabel.fontSize = 48
        
        let coinLabel = self.childNode(withName: "Coin Label") as! SKLabelNode
        coinLabel.fontName = "Blow"
        highScoreLabel.fontSize = 48
    }
    
}
