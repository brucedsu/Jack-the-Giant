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
    
    private var easyButton: SKSpriteNode?
    private var mediumButton: SKSpriteNode?
    private var hardButton: SKSpriteNode?
    
    private var checkSign: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        initializeVariables()
        
        setCheckSignPosition()
    }
    
    func initializeVariables() {
        backButton = self.childNode(withName: "Back Button") as? SKSpriteNode

        easyButton = self.childNode(withName: "Easy Button") as? SKSpriteNode
        mediumButton = self.childNode(withName: "Medium Button") as? SKSpriteNode
        hardButton = self.childNode(withName: "Hard Button") as? SKSpriteNode
        
        checkSign = self.childNode(withName: "Check Sign") as? SKSpriteNode
    }
    
    func setCheckSignPosition() {
        if GameManager.instance.getEasyDifficulty() == true {
            checkSign?.position.y = (easyButton?.position.y)!
        } else if GameManager.instance.getMediumDifficulty() == true {
            checkSign?.position.y = (mediumButton?.position.y)!
        } else if GameManager.instance.getHardDifficulty() == true {
            checkSign?.position.y = (hardButton?.position.y)!
        }
    }
    
    private func setDifficulty(difficulty: String) {
        switch difficulty {
        case "easy":
            GameManager.instance.setEasyDifficulty(true)
            GameManager.instance.setMediumDifficulty(false)
            GameManager.instance.setHardDifficulty(false)
            break
        case "medium":
            GameManager.instance.setEasyDifficulty(false)
            GameManager.instance.setMediumDifficulty(true)
            GameManager.instance.setHardDifficulty(false)
            break
        case "hard":
            GameManager.instance.setEasyDifficulty(false)
            GameManager.instance.setMediumDifficulty(false)
            GameManager.instance.setHardDifficulty(true)
            break
        default:
            break
        }
        
        GameManager.instance.saveData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if nodes(at: location).contains(easyButton!) {
                setDifficulty(difficulty: "easy")
                checkSign?.position.y = (easyButton?.position.y)!
            } else if nodes(at: location).contains(mediumButton!) {
                setDifficulty(difficulty: "medium")
                checkSign?.position.y = (mediumButton?.position.y)!
            } else if nodes(at: location).contains(hardButton!) {
                setDifficulty(difficulty: "hard")
                checkSign?.position.y = (hardButton?.position.y)!
            } else if nodes(at: location).contains(backButton!) {
                let scene = MainMenuScene(fileNamed: "MainMenuScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(
                    scene!,
                    transition: SKTransition.flipHorizontal(withDuration: 1))
            }
            
            checkSign?.zPosition = 4
        }
    }
    
}
