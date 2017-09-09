//
//  MainMenuScene.swift
//  Jack the Giant
//
//  Created by Hejia Su on 9/8/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    var highScoreButton: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        highScoreButton = self.childNode(withName: "High Score") as? SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if self.nodes(at: location).contains(highScoreButton!) {  
                let scene = HighScoreScene(fileNamed: "HighScoreScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(
                    scene!,
                    transition: SKTransition.doorsOpenVertical(withDuration: 1))
            }
        }
    }
    
}
