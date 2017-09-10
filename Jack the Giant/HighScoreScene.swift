//
//  HighScoreScene.swift
//  Jack the Giant
//
//  Created by Hejia Su on 9/8/17.
//  Copyright © 2017 Watermelon Studio. All rights reserved.
//

import SpriteKit

class HighScoreScene: SKScene {
    
    private var scoreLabel: SKLabelNode?
    private var coinLabel: SKLabelNode?
    
    var backButton: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        let highScoreLabel = self.childNode(withName: "Score Label") as! SKLabelNode
        highScoreLabel.fontName = "Blow"
        highScoreLabel.fontSize = 48
        
        let coinLabel = self.childNode(withName: "Coin Label") as! SKLabelNode
        coinLabel.fontName = "Blow"
        highScoreLabel.fontSize = 48
        
        backButton = self.childNode(withName: "Back Button") as? SKSpriteNode
        
        getReference()
        
        setScore()
    }
    
    private func getReference() {
        scoreLabel = self.childNode(withName: "Score Label") as? SKLabelNode
        coinLabel = self.childNode(withName: "Coin Label") as? SKLabelNode
    }
    
    private func setScore() {
        if GameManager.instance.getEasyDifficulty() == true {
            scoreLabel?.text = String(GameManager.instance.getEasyDifficultyScore())
            coinLabel?.text = String(GameManager.instance.getEasyDifficultyCoinScore())
        } else if GameManager.instance.getMediumDifficulty() == true {
            scoreLabel?.text = String(GameManager.instance.getMediumDifficultyScore())
            coinLabel?.text = String(GameManager.instance.getMediumDifficultyCoinScore())
        } else if GameManager.instance.getHardDifficulty() == true {
            scoreLabel?.text = String(GameManager.instance.getHardDifficultyScore())
            coinLabel?.text = String(GameManager.instance.getHardDifficultyCoinScore())
        }
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
