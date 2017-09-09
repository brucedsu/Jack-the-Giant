//
//  MainMenuScene.swift
//  Jack the Giant
//
//  Created by Hejia Su on 9/8/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    var startGameButton: SKSpriteNode?
    var highScoreButton: SKSpriteNode?
    var optionButton: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        startGameButton = self.childNode(withName: "Start Game") as? SKSpriteNode
        highScoreButton = self.childNode(withName: "High Score") as? SKSpriteNode
        optionButton = self.childNode(withName: "Options") as? SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if self.nodes(at: location).contains(startGameButton!) {
                GameManager.instance.gameStartedFromMainMenu = true
                
                let scene = GameplayScene(fileNamed: "GameplayScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(
                    scene!,
                    transition: SKTransition.crossFade(withDuration: 1))
            } else if self.nodes(at: location).contains(highScoreButton!) {
                let scene = HighScoreScene(fileNamed: "HighScoreScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(
                    scene!,
                    transition: SKTransition.doorsOpenVertical(withDuration: 1))
            } else if self.nodes(at: location).contains(optionButton!) {
                let scene = OptionScene(fileNamed: "OptionScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(
                    scene!,
                    transition: SKTransition.flipHorizontal(withDuration: 1))
            }
        }
    }
    
}
