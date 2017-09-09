//
//  OptionScene.swift
//  Jack the Giant
//
//  Created by Hejia Su on 9/8/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import SpriteKit

class OptionScene: SKScene {
    
    var backButton: SKSpriteNode?
    
    override func didMove(to view: SKView) {
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
                    transition: SKTransition.flipHorizontal(withDuration: 1))
            }
        }
    }
    
}
